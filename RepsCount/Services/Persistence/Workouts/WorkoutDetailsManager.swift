import SwiftUI
import Combine
import CoreData

protocol WorkoutDetailsManagerInterface {

    var workoutPublisher: AnyPublisher<WorkoutInstance?, Never> { get }
    var errorPublisher: PassthroughSubject<CoreError, Never> { get }

    func updateName(_ name: String)
    func markAsComplete()
    func addExercise(_ exercise: WorkoutTemplateExercise, savesLocation: Bool)
    func deleteExercise(_ exercise: Exercise)
    func deleteWorkout()
}

final class WorkoutDetailsManager: WorkoutDetailsManagerInterface {

    var workoutPublisher: AnyPublisher<WorkoutInstance?, Never> {
        workoutSubject.eraseToAnyPublisher()
    }
    let errorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface
    private let locationManager: LocationManagerInterface

    private let workoutSubject = CurrentValueSubject<WorkoutInstance?, Never>(nil)
    private var cdWorkoutInstance: CDWorkoutInstance?
    private var cancellables: Set<AnyCancellable> = []

    init(
        workoutID: String,
        coreDataService: CoreDataServiceInterface,
        locationManager: LocationManagerInterface
    ) {
        self.coreDataService = coreDataService
        self.locationManager = locationManager
        fetchWorkout(with: workoutID)
        setupBindings()
    }

    func updateName(_ name: String) {
        guard let cdWorkoutInstance else {
            errorPublisher.send(.unknownError)
            return
        }
        guard name.isNotEmpty else {
            errorPublisher.send(.internalError(.inputCannotBeEmpty))
            return
        }
        cdWorkoutInstance.name = name
        saveContext()
    }

    func markAsComplete() {
        guard let cdWorkoutInstance else {
            errorPublisher.send(.unknownError)
            return
        }
        if cdWorkoutInstance._exercises.isEmpty {
            errorPublisher.send(.internalError(.unableToCompleteEmptyWorkout))
            return
        }
        cdWorkoutInstance.completionTimeStamp = .now
        saveContext()
    }

    func addExercise(_ exercise: WorkoutTemplateExercise, savesLocation: Bool) {
        Task {
            let newCDExercise = CDExercise(context: coreDataService.context)
            newCDExercise.timestamp = .now
            newCDExercise.name = exercise.exerciseModel.rawValue
            newCDExercise.id = UUID().uuidString
            newCDExercise.defaultAmount = exercise.defaultAmount
            newCDExercise.defaultSets = exercise.defaultSets
            if savesLocation, let location = try await locationManager.getCurrentLocation() {
                newCDExercise.latitude = location.latitude
                newCDExercise.longitude = location.longitude
                newCDExercise.address = location.address
            }
            newCDExercise.workoutInstance = cdWorkoutInstance
            cdWorkoutInstance?.addToExercises(newCDExercise)
            saveContext()
        }
    }

    func deleteExercise(_ exercise: Exercise) {
        let request = CDExercise.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", exercise.id)

        do {
            if let object = try coreDataService.context.fetch(request).first {
                coreDataService.context.delete(object)
                saveContext()
            } else {
                throw CoreError.internalError(.removingExerciseFailed)
            }
        } catch {
            errorPublisher.send(.internalError(.removingExerciseFailed))
        }
    }

    func deleteWorkout() {
        guard let cdWorkoutInstance else {
            errorPublisher.send(.unknownError)
            return
        }
        cdWorkoutInstance._exercises.forEach { exercise in
            coreDataService.context.delete(exercise)
        }
        coreDataService.context.delete(cdWorkoutInstance)
        saveContext()
    }

    private func fetchWorkout(with id: String) {
        let fetchRequest = CDWorkoutInstance.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            if let cdWorkoutInstance = try coreDataService.context.fetch(fetchRequest).first {
                self.cdWorkoutInstance = cdWorkoutInstance
                workoutSubject.send(cdWorkoutInstance.coreModel)
            }
        } catch {
            errorPublisher.send(.storageError(.readFailed))
        }
    }

    private func saveContext() {
        do {
            try coreDataService.saveContext()
        } catch {
            errorPublisher.send(.storageError(.saveFailed))
        }
    }

    private func setupBindings() {
        coreDataService.dataUpdatedPublisher
            .sink { [weak self] _ in
                if let id = self?.cdWorkoutInstance?.id {
                    self?.fetchWorkout(with: id)
                }
            }
            .store(in: &cancellables)
    }
}

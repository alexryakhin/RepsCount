import SwiftUI
import Combine
import CoreData
import Core

public protocol WorkoutDetailsManagerInterface {

    var workoutPublisher: AnyPublisher<WorkoutInstance?, Never> { get }
    var errorPublisher: PassthroughSubject<CoreError, Never> { get }

    func updateName(_ name: String)
    func markAsComplete()
    func addExercise(_ exercise: WorkoutTemplateExercise, savesLocation: Bool)
    func deleteExercise(_ exercise: Exercise)
    func deleteWorkout()
}

public final class WorkoutDetailsManager: WorkoutDetailsManagerInterface {

    public var workoutPublisher: AnyPublisher<WorkoutInstance?, Never> {
        workoutSubject.eraseToAnyPublisher()
    }
    public let errorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface
    private let locationManager: LocationManagerInterface

    private let workoutSubject = CurrentValueSubject<WorkoutInstance?, Never>(nil)
    private var cdWorkoutInstance: CDWorkoutInstance?
    private var cancellables: Set<AnyCancellable> = []

    public init(
        workoutID: String,
        coreDataService: CoreDataServiceInterface,
        locationManager: LocationManagerInterface
    ) {
        self.coreDataService = coreDataService
        self.locationManager = locationManager
        fetchWorkout(with: workoutID)
    }

    public func updateName(_ name: String) {
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

    public func markAsComplete() {
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

    public func addExercise(_ exercise: WorkoutTemplateExercise, savesLocation: Bool) {
        Task {
            let newCDExercise = CDExercise(context: coreDataService.context)
            newCDExercise.timestamp = .now
            newCDExercise.name = exercise.exerciseModel.rawValue
            newCDExercise.id = UUID().uuidString
            newCDExercise.defaultReps = exercise.defaultReps.int64
            newCDExercise.defaultSets = exercise.defaultSets.int64
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

    public func deleteExercise(_ exercise: Exercise) {
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

    public func deleteWorkout() {
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
            workoutSubject.send(cdWorkoutInstance?.coreModel)
        } catch {
            errorPublisher.send(.storageError(.saveFailed))
        }
    }
}

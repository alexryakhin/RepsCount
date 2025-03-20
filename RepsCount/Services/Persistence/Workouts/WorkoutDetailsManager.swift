import SwiftUI
import Combine
import CoreData
import Core

public protocol WorkoutDetailsManagerInterface {

    var workoutPublisher: AnyPublisher<WorkoutInstance?, Never> { get }
    var errorPublisher: PassthroughSubject<CoreError, Never> { get }

    func markAsComplete()
    func deleteExercise(_ exercise: Exercise)
    func deleteWorkout()
}

public final class WorkoutDetailsManager: WorkoutDetailsManagerInterface {

    public var workoutPublisher: AnyPublisher<WorkoutInstance?, Never> {
        workoutSubject.eraseToAnyPublisher()
    }
    public let errorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface

    private let workoutSubject = CurrentValueSubject<WorkoutInstance?, Never>(nil)
    private var cdWorkoutInstance: CDWorkoutInstance?
    private var cancellables: Set<AnyCancellable> = []

    public init(
        workoutID: String,
        coreDataService: CoreDataServiceInterface
    ) {
        self.coreDataService = coreDataService
        fetchWorkout(with: workoutID)
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

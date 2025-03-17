import SwiftUI
import Combine
import CoreData
import Core

public protocol ExerciseDetailsManagerInterface {

    var exercisePublisher: AnyPublisher<Exercise?, Never> { get }
    var errorPublisher: PassthroughSubject<CoreError, Never> { get }

    func addSet(_ amount: Double, weight: Double)
    func deleteSet(atOffsets offsets: IndexSet)
    func updateNotes(_ notes: String?)
}

public final class ExerciseDetailsManager: ExerciseDetailsManagerInterface {

    public var exercisePublisher: AnyPublisher<Exercise?, Never> {
        _exercisePublisher.eraseToAnyPublisher()
    }
    public let errorPublisher = PassthroughSubject<CoreError, Never>()

    private let exerciseID: String
    private let coreDataService: CoreDataServiceInterface

    private let _exercisePublisher = CurrentValueSubject<Exercise?, Never>(nil)
    private var cdExercise: CDExercise?
    private var cancellables: Set<AnyCancellable> = []

    public init(
        exerciseID: String,
        coreDataService: CoreDataServiceInterface
    ) {
        self.exerciseID = exerciseID
        self.coreDataService = coreDataService
        fetchExercise()
    }

    public func addSet(_ amount: Double, weight: Double) {
        let newItem = CDExerciseSet(context: coreDataService.context)
        newItem.timestamp = .now
        newItem.id = UUID().uuidString
        newItem.amount = amount
        newItem.exercise = cdExercise
        newItem.weight = weight
        saveContext()
    }

    public func deleteSet(atOffsets offsets: IndexSet) {
        offsets.compactMap { cdExercise?._exerciseSets[$0] }.forEach(coreDataService.context.delete)
        saveContext()
    }

    public func updateNotes(_ notes: String?) {
        cdExercise?.notes = notes
        saveContext()
    }

    private func fetchExercise() {
        let fetchRequest: NSFetchRequest<CDExercise> = CDExercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", exerciseID)
        do {
            if let cdExercise: CDExercise = try coreDataService.context.fetch(fetchRequest).first {
                self.cdExercise = cdExercise
                _exercisePublisher.send(cdExercise.coreModel)
            }
        } catch {
            errorPublisher.send(.storageError(.readFailed))
        }
    }

    private func saveContext() {
        do {
            try coreDataService.saveContext()
            _exercisePublisher.send(cdExercise?.coreModel)
        } catch {
            errorPublisher.send(.internalError(.removingExerciseFailed))
        }
    }
}

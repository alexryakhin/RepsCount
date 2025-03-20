import SwiftUI
import Combine
import CoreData
import Core

public protocol WorkoutTemplateManagerInterface {

    var workoutTemplatePublisher: AnyPublisher<WorkoutTemplate?, Never> { get }
    var errorPublisher: PassthroughSubject<CoreError, Never> { get }

    func updateName(_ name: String)
    func updateNotes(_ notes: String?)
    func updateExercises(_ exerciseTemplates: [WorkoutTemplateExercise])

    func createNewWorkoutTemplate(
        name: String,
        notes: String?,
        exerciseTemplates: [WorkoutTemplateExercise]
    )
}

public final class WorkoutTemplatesManager: WorkoutTemplateManagerInterface {

    public var workoutTemplatePublisher: AnyPublisher<WorkoutTemplate?, Never> {
        workoutTemplateSubject.eraseToAnyPublisher()
    }
    public let errorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface

    private let workoutTemplateSubject = CurrentValueSubject<WorkoutTemplate?, Never>(nil)
    private var cdWorkoutTemplate: CDWorkoutTemplate?
    private var cancellables: Set<AnyCancellable> = []

    public init(
        workoutTemplateID: String?,
        coreDataService: CoreDataServiceInterface
    ) {
        self.coreDataService = coreDataService
        if let workoutTemplateID {
            fetchWorkoutTemplate(with: workoutTemplateID)
        }
    }

    public func updateName(_ name: String) {
        cdWorkoutTemplate?.name = name
    }

    public func updateNotes(_ notes: String?) {
        cdWorkoutTemplate?.notes = notes
        saveContext()
    }

    public func updateExercises(_ exerciseTemplates: [WorkoutTemplateExercise]) {
        guard let cdWorkoutTemplate else { return }
        cdWorkoutTemplate._templateExercises.forEach { [weak self] in
            self?.coreDataService.context.delete($0)
        }
        for exerciseTemplate in exerciseTemplates {
            let templateExercise = CDWorkoutTemplateExercise(context: coreDataService.context)
            templateExercise.id = exerciseTemplate.id
            templateExercise.defaultReps = exerciseTemplate.defaultReps.int64
            templateExercise.defaultSets = exerciseTemplate.defaultSets.int64
            templateExercise.exerciseModel = exerciseTemplate.exerciseModel.rawValue
            templateExercise.sortingOrder = exerciseTemplate.sortingOrder.int64
            templateExercise.workoutTemplate = cdWorkoutTemplate
            cdWorkoutTemplate.addToTemplateExercises(templateExercise)
        }
        saveContext()
    }

    public func createNewWorkoutTemplate(
        name: String,
        notes: String?,
        exerciseTemplates: [WorkoutTemplateExercise]
    ) {
        let cdWorkoutTemplate = CDWorkoutTemplate(context: coreDataService.context)
        cdWorkoutTemplate.id = UUID().uuidString
        cdWorkoutTemplate.name = name
        cdWorkoutTemplate.notes = notes
        for (index, exerciseTemplate) in exerciseTemplates.enumerated() {
            let templateExercise = CDWorkoutTemplateExercise(context: coreDataService.context)
            templateExercise.id = exerciseTemplate.id
            templateExercise.defaultReps = exerciseTemplate.defaultReps.int64
            templateExercise.defaultSets = exerciseTemplate.defaultSets.int64
            templateExercise.exerciseModel = exerciseTemplate.exerciseModel.rawValue
            templateExercise.sortingOrder = index.int64
            templateExercise.workoutTemplate = cdWorkoutTemplate
            cdWorkoutTemplate.addToTemplateExercises(templateExercise)
        }
        saveContext()
    }

    private func fetchWorkoutTemplate(with workoutTemplateID: String) {
        let fetchRequest = CDWorkoutTemplate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", workoutTemplateID)
        do {
            if let cdWorkoutTemplate: CDWorkoutTemplate = try coreDataService.context.fetch(fetchRequest).first {
                self.cdWorkoutTemplate = cdWorkoutTemplate
                workoutTemplateSubject.send(cdWorkoutTemplate.coreModel)
            }
        } catch {
            errorPublisher.send(.storageError(.readFailed))
        }
    }

    private func saveContext() {
        do {
            try coreDataService.saveContext()
            workoutTemplateSubject.send(cdWorkoutTemplate?.coreModel)
        } catch {
            errorPublisher.send(.storageError(.saveFailed))
        }
    }
}

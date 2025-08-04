import SwiftUI
import Combine
import CoreData

protocol WorkoutTemplateManagerInterface {

    var workoutTemplatePublisher: AnyPublisher<WorkoutTemplate?, Never> { get }
    var errorPublisher: PassthroughSubject<CoreError, Never> { get }

    func updateName(_ name: String)
    func updateNotes(_ notes: String?)
    func addExerciseTemplate(_ exerciseTemplate: WorkoutTemplateExercise)
    func updateExerciseTemplate(_ exerciseTemplate: WorkoutTemplateExercise)
    func deleteExerciseTemplate(_ exerciseTemplate: WorkoutTemplateExercise)

    func createNewWorkoutTemplate(
        name: String,
        notes: String?,
        exerciseTemplates: [WorkoutTemplateExercise]
    )
}

final class WorkoutTemplatesManager: WorkoutTemplateManagerInterface {

    var workoutTemplatePublisher: AnyPublisher<WorkoutTemplate?, Never> {
        workoutTemplateSubject.eraseToAnyPublisher()
    }
    let errorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface

    private let workoutTemplateSubject = CurrentValueSubject<WorkoutTemplate?, Never>(nil)
    private var cdWorkoutTemplate: CDWorkoutTemplate?
    private var cancellables: Set<AnyCancellable> = []

    init(
        workoutTemplateID: String?,
        coreDataService: CoreDataServiceInterface
    ) {
        self.coreDataService = coreDataService
        if let workoutTemplateID {
            fetchWorkoutTemplate(with: workoutTemplateID)
        }
    }

    func updateName(_ name: String) {
        cdWorkoutTemplate?.name = name
        saveContext()
    }

    func updateNotes(_ notes: String?) {
        cdWorkoutTemplate?.notes = notes
        saveContext()
    }

    func addExerciseTemplate(_ exerciseTemplate: WorkoutTemplateExercise) {
        let templateExercise = CDWorkoutTemplateExercise(context: coreDataService.context)
        templateExercise.id = exerciseTemplate.id
        templateExercise.defaultAmount = exerciseTemplate.defaultAmount
        templateExercise.defaultSets = exerciseTemplate.defaultSets
        templateExercise.exerciseModel = exerciseTemplate.exerciseModel.rawValue
        templateExercise.timestamp = exerciseTemplate.timestamp
        templateExercise.workoutTemplate = cdWorkoutTemplate
        cdWorkoutTemplate?.addToTemplateExercises(templateExercise)
        saveContext()
    }

    func updateExerciseTemplate(_ exerciseTemplate: WorkoutTemplateExercise) {
        if let cdExerciseTemplate = fetchExerciseTemplate(with: exerciseTemplate.id) {
            cdExerciseTemplate.defaultAmount = exerciseTemplate.defaultAmount
            cdExerciseTemplate.defaultSets = exerciseTemplate.defaultSets
            saveContext()
        }
    }

    func deleteExerciseTemplate(_ exerciseTemplate: WorkoutTemplateExercise) {
        if let cdExerciseTemplate = fetchExerciseTemplate(with: exerciseTemplate.id) {
            coreDataService.context.delete(cdExerciseTemplate)
            saveContext()
        }
    }

    private func fetchExerciseTemplate(with id: String) -> CDWorkoutTemplateExercise? {
        let fetchRequest = CDWorkoutTemplateExercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try coreDataService.context.fetch(fetchRequest).first
        } catch {
            errorPublisher.send(.storageError(.readFailed))
            return nil
        }
    }

    func createNewWorkoutTemplate(
        name: String,
        notes: String?,
        exerciseTemplates: [WorkoutTemplateExercise]
    ) {
        let cdWorkoutTemplate = CDWorkoutTemplate(context: coreDataService.context)
        cdWorkoutTemplate.id = UUID().uuidString
        cdWorkoutTemplate.name = name
        cdWorkoutTemplate.notes = notes
        for exerciseTemplate in exerciseTemplates {
            let templateExercise = CDWorkoutTemplateExercise(context: coreDataService.context)
            templateExercise.id = exerciseTemplate.id
            templateExercise.defaultAmount = exerciseTemplate.defaultAmount
            templateExercise.defaultSets = exerciseTemplate.defaultSets
            templateExercise.exerciseModel = exerciseTemplate.exerciseModel.rawValue
            templateExercise.timestamp = exerciseTemplate.timestamp
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

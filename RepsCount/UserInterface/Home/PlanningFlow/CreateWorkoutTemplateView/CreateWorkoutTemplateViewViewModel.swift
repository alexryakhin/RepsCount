import Combine
import Foundation

final class CreateWorkoutTemplateViewViewModel: BaseViewModel {

    enum Input {
        case saveTemplate
        case editDefaults(WorkoutTemplateExercise)
        case applyEditing(WorkoutTemplateExercise)
        case toggleAddExerciseSheet
        case addExercise(WorkoutTemplateExercise)
        case removeExercise(WorkoutTemplateExercise)
        case updateName
        case updateNotes
    }

    enum Output {
        case dismiss
    }

    let output = PassthroughSubject<Output, Never>()

    @Published var workoutName: String = ""
    @Published var workoutNotes: String = ""
    @Published var defaultSetsInput: String = ""
    @Published var defaultAmountInput: String = ""
    @Published var editingDefaultsExercise: WorkoutTemplateExercise?
    @Published var isShowingAddExerciseSheet: Bool = false

    @Published private(set) var isEditing: Bool = false
    @Published private(set) var exercises: [WorkoutTemplateExercise] = []

    // MARK: - Private Properties

    private let workoutTemplatesManager: WorkoutTemplateManagerInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(workoutTemplateID: String?) {
        self.workoutTemplatesManager = ServiceManager.shared.createWorkoutTemplateManager(workoutTemplateID: workoutTemplateID ?? "")
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .saveTemplate:
            saveTemplate()
        case .editDefaults(let exercise):
            editDefaults(for: exercise)
        case .applyEditing(let exercise):
            applyEditing(for: exercise)
        case .toggleAddExerciseSheet:
            isShowingAddExerciseSheet.toggle()
        case .addExercise(let exercise):
            if isEditing {
                workoutTemplatesManager.addExerciseTemplate(exercise)
            } else {
                exercises.append(exercise)
            }
        case .removeExercise(let exercise):
            workoutTemplatesManager.deleteExerciseTemplate(exercise)
        case .updateName:
            workoutTemplatesManager.updateName(workoutName)
        case .updateNotes:
            workoutTemplatesManager.updateNotes(workoutNotes)
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        workoutTemplatesManager.workoutTemplatePublisher
            .compactMap { $0 }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] template in
                guard let self else { return }
                isEditing = true
                workoutName = template.name
                workoutNotes = template.notes.orEmpty
                exercises = template.templateExercises
            }
            .store(in: &cancellables)
    }

    private func saveTemplate() {
        guard workoutName.isNotEmpty else {
            showAlert(withModel: .init(title: LocalizationKeys.Alerts.emptyName, message: LocalizationKeys.Alerts.emptyNameMessage))
            return
        }
        guard exercises.isNotEmpty else {
            showAlert(withModel: .init(title: LocalizationKeys.Alerts.emptyExercises, message: LocalizationKeys.Alerts.emptyExercisesMessage))
            return
        }
        workoutTemplatesManager.createNewWorkoutTemplate(
            name: workoutName,
            notes: workoutNotes.nilIfEmpty,
            exerciseTemplates: exercises
        )
        output.send(.dismiss)
    }

    private func editDefaults(for exercise: WorkoutTemplateExercise) {
        defaultSetsInput = exercise.defaultSets == 0 ? "" : exercise.defaultSets.formatted()
        defaultAmountInput = exercise.defaultAmount == 0 ? "" : exercise.defaultAmount.formatted()
        editingDefaultsExercise = exercise
    }

    private func applyEditing(for exercise: WorkoutTemplateExercise) {
        if let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
            exercises[index].defaultSets = Double(defaultSetsInput) ?? 0
            exercises[index].defaultAmount = Double(defaultAmountInput) ?? 0
            workoutTemplatesManager.updateExerciseTemplate(exercises[index])
        }
        defaultSetsInput = ""
        defaultAmountInput = ""
        editingDefaultsExercise = nil
    }
}

import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine

public final class CreateWorkoutTemplateViewViewModel: DefaultPageViewModel {

    enum Input {
        case toggleExerciseSelection(ExerciseModel)
        case appendNewExercise(ExerciseModel)
        case saveTemplate
        case editDefaults(WorkoutTemplateExercise)
        case applyEditing(WorkoutTemplateExercise)
    }

    enum Output {
        case dismiss
    }

    var onOutput: ((Output) -> Void)?

    @Published var workoutName: String = ""
    @Published var workoutNotes: String = ""
    @Published var defaultSetsInput: String = ""
    @Published var defaultRepsInput: String = ""
    @Published var exerciseModelToAdd: ExerciseModel?
    @Published var editingDefaultsExercise: WorkoutTemplateExercise?
    @Published var selectedEquipment: Set<ExerciseEquipment> = Set(ExerciseEquipment.allCases)

    @Published private(set) var isEditing: Bool = false
    @Published private(set) var exercises: [WorkoutTemplateExercise] = []

    // MARK: - Private Properties

    private let workoutTemplatesManager: WorkoutTemplateManagerInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(workoutTemplatesManager: WorkoutTemplateManagerInterface) {
        self.workoutTemplatesManager = workoutTemplatesManager
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .toggleExerciseSelection(let model):
            if let index = exercises.firstIndex(where: { $0.exerciseModel.rawValue == model.rawValue }) {
                exercises.remove(at: index)
            } else {
                exerciseModelToAdd = model
            }
        case .appendNewExercise(let model):
            appendNewExercise(model)
        case .saveTemplate:
            saveTemplate()
        case .editDefaults(let exercise):
            editDefaults(for: exercise)
        case .applyEditing(let exercise):
            applyEditing(for: exercise)
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        $selectedEquipment
            .sink { [weak self] equipment in
                guard let self else { return }
                exercises = exercises.filter { equipment.contains($0.exerciseModel.equipment) }
            }
            .store(in: &cancellables)

        workoutTemplatesManager.workoutTemplatePublisher
            .removeDuplicates()
            .sink { [weak self] template in
                guard let self else { return }
                if let template {
                    isEditing = true
                    workoutName = template.name
                    workoutNotes = template.notes.orEmpty
                    exercises = template.templateExercises
                }
            }
            .store(in: &cancellables)
    }

    private func saveTemplate() {
        guard workoutName.isNotEmpty else {
            showAlert(withModel: .init(title: "Empty name", message: "Name of the workout template cannot be empty"))
            return
        }
        guard exercises.isNotEmpty else {
            showAlert(withModel: .init(title: "Empty exercises", message: "You should add at least one exercise"))
            return
        }
        if isEditing {
            workoutTemplatesManager.updateExercises(exercises)
            onOutput?(.dismiss)
        } else {
            workoutTemplatesManager.createNewWorkoutTemplate(
                name: workoutName,
                notes: workoutNotes.nilIfEmpty,
                exerciseTemplates: exercises
            )
            onOutput?(.dismiss)
        }
    }

    private func appendNewExercise(_ model: ExerciseModel) {
        exercises.append(
            .init(
                id: UUID().uuidString,
                exerciseModel: model,
                defaultSets: Int(defaultSetsInput) ?? 0,
                defaultReps: Int(defaultRepsInput) ?? 0,
                sortingOrder: exercises.count
            )
        )
        defaultSetsInput = ""
        defaultRepsInput = ""
        exerciseModelToAdd = nil
    }

    private func editDefaults(for exercise: WorkoutTemplateExercise) {
        defaultSetsInput = exercise.defaultSets.formatted()
        defaultRepsInput = exercise.defaultReps.formatted()
        editingDefaultsExercise = exercise
    }

    private func applyEditing(for exercise: WorkoutTemplateExercise) {
        if let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
            exercises[index].defaultSets = Int(defaultSetsInput) ?? 0
            exercises[index].defaultReps = Int(defaultRepsInput) ?? 0
        }
        defaultSetsInput = ""
        defaultRepsInput = ""
        editingDefaultsExercise = nil
    }
}

import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine

public final class CreateWorkoutTemplateViewViewModel: DefaultPageViewModel {

    enum Input {
        case toggleExerciseSelection(ExerciseModel)
        case saveTemplate
    }

    enum Output {
        case dismiss
    }

    var onOutput: ((Output) -> Void)?

    @Published var workoutName: String = ""
    @Published var workoutNotes: String = ""
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
                exercises.append(
                    .init(
                        id: UUID().uuidString,
                        exerciseModel: model,
                        defaultSets: 0,
                        defaultReps: 0,
                        sortingOrder: exercises.count
                    )
                )
            }
        case .saveTemplate:
            saveTemplate()
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
}

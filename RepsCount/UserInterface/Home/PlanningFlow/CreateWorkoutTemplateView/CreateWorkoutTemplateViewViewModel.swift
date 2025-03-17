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
        // Output actions to pass to the view controller
    }

    var onOutput: ((Output) -> Void)?

    @Published var workoutName: String = ""
    @Published var workoutNotes: String = ""
    @Published var selectedEquipment: Set<ExerciseEquipment> = Set(ExerciseEquipment.allCases)

    @Published private(set) var isEditing: Bool = false
    @Published private(set) var selectedExercises: [ExerciseModel] = []

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(arg: Int) {
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .toggleExerciseSelection(let model):
            if let index = selectedExercises.firstIndex(where: { $0.rawValue == model.rawValue }) {
                selectedExercises.remove(at: index)
            } else {
                selectedExercises.append(model)
            }
        case .saveTemplate:
            break
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        $selectedEquipment
            .sink { [weak self] equipment in
                guard let self else { return }
                selectedExercises = selectedExercises.filter { equipment.contains($0.equipment) }
            }
            .store(in: &cancellables)
    }
}

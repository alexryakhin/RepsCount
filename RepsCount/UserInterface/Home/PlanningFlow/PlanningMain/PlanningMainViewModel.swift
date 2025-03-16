import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine

public final class PlanningMainViewModel: DefaultPageViewModel {

    enum Input {
        case createWorkoutTemplate
        case showWorkoutTemplateDetails(WorkoutTemplate)
    }

    enum Output {
        case createWorkoutTemplate
    }

    var onOutput: ((Output) -> Void)?

    @Published private(set) var workoutTemplates: [WorkoutTemplate] = []

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(arg: Int) {
        super.init()
        setupBindings()
        additionalState = .placeholder()
    }

    func handle(_ input: Input) {
        switch input {
        case .createWorkoutTemplate:
            onOutput?(.createWorkoutTemplate)
        case .showWorkoutTemplateDetails:
            break
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        // Services and Published properties subscriptions
    }
}

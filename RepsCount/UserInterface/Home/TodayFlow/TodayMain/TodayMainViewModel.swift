import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine

public final class TodayMainViewModel: DefaultPageViewModel {

    enum Input {
        case showWorkouts
        case createNewWorkout
        case showWorkoutDetails(WorkoutInstance)
    }

    enum Output {
        // Output actions to pass to the view controller
    }

    var onOutput: ((Output) -> Void)?

    @Published private(set) var todayWorkouts: [WorkoutInstance] = []

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
        case .createNewWorkout:
            break
        case .showWorkouts:
            break
        case .showWorkoutDetails(let workoutInstance):
            break
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        // Services and Published properties subscriptions
    }
}

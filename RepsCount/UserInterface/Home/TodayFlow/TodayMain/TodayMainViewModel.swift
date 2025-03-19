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
        case startPlannedWorkout(WorkoutEvent)
    }

    enum Output {
        // Output actions to pass to the view controller
    }

    var onOutput: ((Output) -> Void)?

    @Published private(set) var plannedWorkouts: [WorkoutEvent] = []
    @Published private(set) var todayWorkouts: [WorkoutInstance] = []

    // MARK: - Private Properties

    private let calendarEventsProvider: WorkoutEventsProviderInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(calendarEventsProvider: WorkoutEventsProviderInterface) {
        self.calendarEventsProvider = calendarEventsProvider
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .createNewWorkout:
            break
        case .showWorkouts:
            break
        case .showWorkoutDetails(let workoutInstance):
            break
        case .startPlannedWorkout(let event):
            startPlannedWorkout(with: event)
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        calendarEventsProvider.eventsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] events in
                let plannedEvents = events
                    .filter { $0.date.startOfDay == Date.now.startOfDay }
                    .sorted(by: { $0.startAt < $1.startAt })
                if plannedEvents.isNotEmpty {
                    self?.plannedWorkouts = plannedEvents
                } else {
                    self?.additionalState = .placeholder()
                }
            }
            .store(in: &cancellables)
    }

    private func startPlannedWorkout(with event: WorkoutEvent) {
        // NewWorkoutManager start workout from event
    }
}

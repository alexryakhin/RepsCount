import Combine
import EventKit

final class CalendarViewModel: BaseViewModel {

    enum Input {
        case scheduleWorkout
        case deleteEvent(WorkoutEvent)
        case handleDeleteEventAlert(WorkoutEvent, deleteFutureEvents: Bool)
    }

    enum Output {
        case scheduleWorkout(configModel: ScheduleEventViewModel.ConfigModel)
        case presentDeleteEventAlert(WorkoutEvent)
    }

    let output = PassthroughSubject<Output, Never>()

    @Published private var events: [WorkoutEvent] = []
    @Published var selectedDate: Date = .now {
        didSet {
            HapticManager.shared.triggerSelection()
            AnalyticsService.shared.logEvent(.calendarScreenDateSelected)
        }
    }

    var eventsForSelectedDate: [WorkoutEvent] {
        events
            .filter { $0.date.startOfDay == selectedDate.startOfDay }
            .sorted(by: { $0.startAt < $1.startAt })
    }

    // MARK: - Private Properties

    private let calendarEventsProvider: WorkoutEventsProviderInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    override init() {
        self.calendarEventsProvider = ServiceManager.shared.workoutEventsProvider
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .scheduleWorkout:
            let configModel = ScheduleEventViewModel.ConfigModel(selectedDate: selectedDate)
            output.send(.scheduleWorkout(configModel: configModel))
        case .deleteEvent(let event):
            output.send(.presentDeleteEventAlert(event))
        case .handleDeleteEventAlert(let event, let deleteFutureEvents):
            calendarEventsProvider.deleteEvent(event, shouldDeleteAllFutureEvents: deleteFutureEvents)
            if deleteFutureEvents {
                AnalyticsService.shared.logEvent(.calendarScreenEventRemoved)
            } else {
                AnalyticsService.shared.logEvent(.calendarScreenEventAndFutureEventsRemoved)
            }
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        calendarEventsProvider.eventsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] events in
                self?.events = events
            }
            .store(in: &cancellables)
    }
}

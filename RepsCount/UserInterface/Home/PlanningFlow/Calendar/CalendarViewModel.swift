import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine

public final class CalendarViewModel: DefaultPageViewModel {

    enum Input {
        case scheduleWorkout
        case editEvent(CalendarEvent)
        case deleteEvent(atOffsets: IndexSet)
    }

    enum Output {
        case scheduleWorkout
        case editEvent(eventId: String)
    }

    var onOutput: ((Output) -> Void)?

    @Published var selectedDate: Date = .now
    @Published var allEvents: [CalendarEvent] = []
    @Published var filteredEvents: [CalendarEvent] = []

    // MARK: - Private Properties

    private let calendarEventsProvider: CalendarEventsProviderInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(calendarEventsProvider: CalendarEventsProviderInterface) {
        self.calendarEventsProvider = calendarEventsProvider
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .scheduleWorkout:
            onOutput?(.scheduleWorkout)
        case .editEvent(let event):
            onOutput?(.editEvent(eventId: event.id))
        case .deleteEvent(let offsets):
            deleteElements(at: offsets)
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        calendarEventsProvider.eventsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] events in
                self?.allEvents = events
            }
            .store(in: &cancellables)
    }

    private func deleteElements(at indices: IndexSet) {
        indices.map { allEvents[$0] }
            .forEach { [weak self] in
                self?.deleteCalendarEvent($0.id)
            }
    }

    private func deleteCalendarEvent(_ id: String) {
//        calendarEventsProvider.delete(with: id)
        // TODO: how to delete an event that is not existing, but a repeated event
    }
}

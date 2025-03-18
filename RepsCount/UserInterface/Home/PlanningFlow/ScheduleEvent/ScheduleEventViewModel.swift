import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine
import EventKit
import SwiftUI

public final class ScheduleEventViewModel: DefaultPageViewModel {

    enum Input {
        case saveEvent
        case selectTemplate(WorkoutTemplate)
        case showCalendarChooser
    }

    enum Output {
        case dismiss
        case showCalendarChooser
    }

    let eventStore: EKEventStore
    var onOutput: ((Output) -> Void)?

    @AppStorage(UDKeys.addToCalendar) var addToCalendar: Bool = false {
        didSet {
            Task {
                await addToCalendarFlatChanged(addToCalendar)
            }
        }
    }

    @Published private(set) var isEditing: Bool = false
    @Published private(set) var workoutTemplates: [WorkoutTemplate] = []
    @Published private(set) var recurrenceRules: [String] = []
    @Published private(set) var selectedTemplate: WorkoutTemplate?

    @Published var selectedRecurrenceRule: String?
    @Published var selectedDate: Date = .now
    @Published var isRecurring: Bool = false
    @Published var isWriteOnlyOrFullAccessAuthorized: Bool = false {
        didSet {
            if !isWriteOnlyOrFullAccessAuthorized {
                addToCalendar = false
            }
        }
    }

    /// Keeps track of the calendars that the user selected in the calendar chooser.
    @Published var calendar: EKCalendar?

    // MARK: - Private Properties

    private let calendarEventManager: CalendarEventManagerInterface
    private let workoutTemplatesProvider: WorkoutTemplatesProviderInterface
    private let eventStoreManager: EventStoreManagerInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        calendarEventManager: CalendarEventManagerInterface,
        workoutTemplatesProvider: WorkoutTemplatesProviderInterface,
        eventStoreManager: EventStoreManagerInterface
    ) {
        self.calendarEventManager = calendarEventManager
        self.workoutTemplatesProvider = workoutTemplatesProvider
        self.eventStoreManager = eventStoreManager
        self.eventStore = eventStoreManager.store
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .saveEvent:
            saveEvent()
        case .selectTemplate(let template):
            selectedTemplate = template
        case .showCalendarChooser:
            onOutput?(.showCalendarChooser)
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        workoutTemplatesProvider.templatesPublisher
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] templates in
                self?.workoutTemplates = templates
                self?.selectedTemplate = templates.first
            }
            .store(in: &cancellables)

        calendarEventManager.calendarEventPublisher
            .removeDuplicates()
            .sink { [weak self] event in
                guard let self else { return }
                if let event {
                    isEditing = true
                    selectedDate = event.date
                    if let recurrenceRule = event.recurrenceRule {
                        selectedRecurrenceRule = recurrenceRule
                    }
                    selectedTemplate = event.workoutTemplate
                }
            }
            .store(in: &cancellables)

        eventStoreManager.authorizationStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                if #available(iOS 17.0, *) {
                    self?.isWriteOnlyOrFullAccessAuthorized = ($0 == .writeOnly || $0 == .fullAccess)
                } else {
                    // Fall back on earlier versions.
                    self?.isWriteOnlyOrFullAccessAuthorized = $0 == .authorized
                }
            }
            .store(in: &cancellables)
    }

    private func saveEvent() {
        Task { @MainActor in
            await addToCalendarFlatChanged(addToCalendar)

            do {
                guard let selectedTemplate else { fatalError("Selected template is nil") }

                // TODO: create a workout event
//                let workoutEvent = WorkoutEvent(
//                    type: <#WorkoutEventType#>,
//                    name: <#String#>,
//                    days: <#[WorkoutEventDay]#>,
//                    startAt: <#Int#>
//                )

                // TODO: save event to Core Data

                // Save event to the event store

                if addToCalendar {
                    print("DEBUG50 adding to calendar")
//                    try await eventStoreManager.saveWorkoutEvent(workoutEvent, date: selectedDate, calendar: calendar)
                }

                onOutput?(.dismiss)
            } catch {
                errorReceived(error, displayType: .alert)
            }
        }
    }

    private func addToCalendarFlatChanged(_ newValue: Bool) async {
        if newValue, !isWriteOnlyOrFullAccessAuthorized {
            do {
                try await eventStoreManager.setupEventStore()
            } catch {
                await MainActor.run {
                    addToCalendar = false
                    errorReceived(error, displayType: .alert)
                }
            }
        }
    }
}

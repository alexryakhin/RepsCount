import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine
import EventKit
import SwiftUI

public final class ScheduleEventViewModel: DefaultPageViewModel {

    public struct ConfigModel {
        public let selectedDate: Date
    }

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
                await addToCalendarFlagChanged(addToCalendar)
            }
        }
    }

    @Published private(set) var workoutTemplates: [WorkoutTemplate] = []
    @Published private(set) var selectedTemplate: WorkoutTemplate?

    /// Specifies the days on which the workout event occur.
    @Published var days: [WorkoutEventDay] = []

    /// Specifies the workout event recurrence frequency.
    @Published var repeats: WorkoutEventRecurrence = .daily

    /// Specifies the workout event recurrence interval.
    @Published var interval: Int = 1

    /// Specifies how often the workout event occurs.
    @Published var occurrenceCount: Int = 1

    /// Specifies the duration of the workout
    @Published var duration: WorkoutEventDuration = .oneHour

    @Published var isRecurring: Bool = false
    @Published var selectedDate: Date
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

    private let workoutEventManager: WorkoutEventManagerInterface
    private let workoutTemplatesProvider: WorkoutTemplatesProviderInterface
    private let eventStoreManager: EventStoreManagerInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        configModel: ConfigModel,
        workoutEventManager: WorkoutEventManagerInterface,
        workoutTemplatesProvider: WorkoutTemplatesProviderInterface,
        eventStoreManager: EventStoreManagerInterface
    ) {
        self.workoutEventManager = workoutEventManager
        self.workoutTemplatesProvider = workoutTemplatesProvider
        self.eventStoreManager = eventStoreManager
        self.eventStore = eventStoreManager.store
        self.selectedDate = configModel.selectedDate
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
            await addToCalendarFlagChanged(addToCalendar)

            do {
                guard let selectedTemplate else { fatalError("Selected template is nil") }
                if isRecurring && repeats == .weekly && days.isEmpty {
                    throw CoreError.internalError(.inputCannotBeEmpty)
                }

                let event = WorkoutEvent(
                    template: selectedTemplate,
                    days: isRecurring ? days : [],
                    startAt: Int(selectedDate.timeIntervalSince(selectedDate.startOfDay)),
                    repeats: isRecurring ? repeats : nil,
                    interval: isRecurring ? interval : nil,
                    occurrenceCount: isRecurring ? occurrenceCount : nil,
                    duration: duration,
                    date: selectedDate,
                    recurrenceId: isRecurring ? UUID().uuidString : nil
                )

                try workoutEventManager.createNewWorkoutEvent(from: event)

                if addToCalendar {
                    try await eventStoreManager.saveWorkoutEvent(event, calendar: calendar)
                }

                onOutput?(.dismiss)
            } catch {
                errorReceived(error, displayType: .alert)
            }
        }
    }

    private func addToCalendarFlagChanged(_ newValue: Bool) async {
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

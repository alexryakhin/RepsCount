import Combine
import SwiftUI

final class TodayMainViewModel: BaseViewModel {

    @AppStorage(UDKeys.savesLocation) var savesLocation: Bool = true

    enum Input {
        case showAllWorkouts
        case showAllExercises
        case createOpenWorkout
        case showAddWorkoutFromTemplate
        case showWorkoutDetails(WorkoutInstance)
        case showDeleteWorkoutAlert(WorkoutInstance)
        case startPlannedWorkout(WorkoutEvent)
        case startWorkoutFromTemplate(WorkoutTemplate)
        case updateDate
    }

    enum Output {
        case showWorkoutDetails(WorkoutInstance)
        case showAllWorkouts
        case showAllExercises
    }

    let output = PassthroughSubject<Output, Never>()

    @Published var isShowingAddWorkoutFromTemplate: Bool = false
    @Published private(set) var currentDate = Date.now
    @Published private(set) var plannedWorkouts: [WorkoutEvent] = []
    @Published private(set) var todayWorkouts: [WorkoutInstance] = []
    @Published private(set) var workoutTemplates: [WorkoutTemplate] = []

    // MARK: - Private Properties

    private let calendarEventsProvider: WorkoutEventsProviderInterface
    private let addWorkoutManager: AddWorkoutManagerInterface
    private let workoutsProvider: WorkoutsProviderInterface
    private let workoutTemplatesProvider: WorkoutTemplatesProviderInterface
    private let locationManager: LocationManagerInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    override init() {
        let serviceManager = ServiceManager.shared
        self.calendarEventsProvider = serviceManager.workoutEventsProvider
        self.addWorkoutManager = serviceManager.createAddWorkoutManager()
        self.workoutsProvider = serviceManager.workoutsProvider
        self.workoutTemplatesProvider = serviceManager.workoutTemplatesProvider
        self.locationManager = serviceManager.locationManager
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .showAllWorkouts:
            output.send(.showAllWorkouts)
        case .showAllExercises:
            output.send(.showAllExercises)
        case .showAddWorkoutFromTemplate:
            isShowingAddWorkoutFromTemplate.toggle()
        case .createOpenWorkout:
            createOpenWorkout()
        case .showWorkoutDetails(let workoutInstance):
            output.send(.showWorkoutDetails(workoutInstance))
        case .startPlannedWorkout(let event):
            startPlannedWorkout(with: event)
        case .startWorkoutFromTemplate(let template):
            startWorkoutFromTemplate(template)
        case .showDeleteWorkoutAlert(let workoutInstance):
            showAlert(
                withModel: .init(
                    title: Loc.Today.deleteWorkout.localized,
                    message: Loc.Today.deleteWorkoutMessage.localized,
                    actionText: Loc.Common.cancel.localized,
                    destructiveActionText: Loc.Common.delete.localized,
                    action: {
                        AnalyticsService.shared.logEvent(.todayScreenWorkoutRemoveCancelButtonTapped)
                    },
                    destructiveAction: { [weak self, workoutInstance] in
                        self?.deleteWorkout(workoutInstance)
                        AnalyticsService.shared.logEvent(.todayScreenWorkoutRemoved)
                    }
                )
            )
        case .updateDate:
            if currentDate.startOfDay != .now.startOfDay {
                currentDate = .now
                calendarEventsProvider.fetchEvents()
            }
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        calendarEventsProvider.eventsPublisher
            .combineLatest(workoutsProvider.workoutsPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] events, workouts in
                let todayWorkouts = workouts
                    .filter { $0.date.startOfDay == .now.startOfDay }
                    .sorted(by: { $0.date < $1.date })

                let plannedEvents = events
                    .filter { $0.date.startOfDay == .now.startOfDay }
                    .filter { plannedEvent in
                        !todayWorkouts.contains { $0.id == plannedEvent.id }
                    }
                    .sorted(by: { $0.startAt < $1.startAt })

                self?.todayWorkouts = todayWorkouts
                self?.plannedWorkouts = plannedEvents

                if todayWorkouts.isEmpty && plannedEvents.isEmpty {
                    self?.showPlaceholder(title: Loc.Today.noWorkouts.localized, subtitle: Loc.Today.noWorkoutsDescription.localized)
                } else {
                    self?.resetAdditionalState()
                }
            }
            .store(in: &cancellables)

        locationManager.authorizationStatusPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                self?.savesLocation = (status == .authorizedWhenInUse || status == .authorizedAlways)
            }
            .store(in: &cancellables)

        workoutTemplatesProvider.templatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] templates in
                self?.workoutTemplates = templates
            }
            .store(in: &cancellables)
    }

    private func startPlannedWorkout(with event: WorkoutEvent) {
        Task { @MainActor in
            do {
                if let workoutInstance = try await addWorkoutManager.addWorkout(from: event, savesLocation: savesLocation) {
                    output.send(.showWorkoutDetails(workoutInstance))
                    HapticManager.shared.triggerNotification(type: .success)
                }
            } catch {
                showError(error)
            }
        }
    }

    private func createOpenWorkout() {
        do {
            if let workoutInstance = try addWorkoutManager.addOpenWorkout() {
                output.send(.showWorkoutDetails(workoutInstance))
                HapticManager.shared.triggerNotification(type: .success)
            }
        } catch {
            showError(error)
        }
    }

    private func startWorkoutFromTemplate(_ template: WorkoutTemplate) {
        Task { @MainActor in
            do {
                if let workoutInstance = try await addWorkoutManager.addWorkout(from: template, savesLocation: savesLocation) {
                    output.send(.showWorkoutDetails(workoutInstance))
                    HapticManager.shared.triggerNotification(type: .success)
                }
            } catch {
                showError(error)
            }
        }
    }

    private func deleteWorkout(_ workout: WorkoutInstance) {
        workoutsProvider.delete(with: workout.id)
    }
}

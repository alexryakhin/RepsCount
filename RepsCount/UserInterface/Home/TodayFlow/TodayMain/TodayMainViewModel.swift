import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine
import SwiftUI

public final class TodayMainViewModel: DefaultPageViewModel {

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
    }

    enum Output {
        case showWorkoutDetails(WorkoutInstance)
        case showAllWorkouts
        case showAllExercises
    }

    var onOutput: ((Output) -> Void)?

    @Published var isShowingAddWorkoutFromTemplate: Bool = false
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

    public init(
        calendarEventsProvider: WorkoutEventsProviderInterface,
        addWorkoutManager: AddWorkoutManagerInterface,
        workoutsProvider: WorkoutsProviderInterface,
        workoutTemplatesProvider: WorkoutTemplatesProviderInterface,
        locationManager: LocationManagerInterface
    ) {
        self.calendarEventsProvider = calendarEventsProvider
        self.addWorkoutManager = addWorkoutManager
        self.workoutsProvider = workoutsProvider
        self.workoutTemplatesProvider = workoutTemplatesProvider
        self.locationManager = locationManager
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .showAllWorkouts:
            onOutput?(.showAllWorkouts)
        case .showAllExercises:
            onOutput?(.showAllExercises)
        case .showAddWorkoutFromTemplate:
            isShowingAddWorkoutFromTemplate.toggle()
        case .createOpenWorkout:
            createOpenWorkout()
        case .showWorkoutDetails(let workoutInstance):
            onOutput?(.showWorkoutDetails(workoutInstance))
        case .startPlannedWorkout(let event):
            startPlannedWorkout(with: event)
        case .startWorkoutFromTemplate(let template):
            startWorkoutFromTemplate(template)
        case .showDeleteWorkoutAlert(let workoutInstance):
            showAlert(
                withModel: .init(
                    title: "Delete workout",
                    message: "Are you sure you want to delete this workout?",
                    actionText: "Cancel",
                    destructiveActionText: "Delete",
                    action: {/* Cancel action, do nothing */},
                    destructiveAction: { [weak self, workoutInstance] in
                        self?.deleteWorkout(workoutInstance)
                    }
                )
            )
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
                    self?.additionalState = .placeholder()
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
                    onOutput?(.showWorkoutDetails(workoutInstance))
                    HapticManager.shared.triggerNotification(type: .success)
                }
            } catch {
                errorReceived(error, displayType: .alert)
            }
        }
    }

    private func createOpenWorkout() {
        do {
            if let workoutInstance = try addWorkoutManager.addOpenWorkout() {
                onOutput?(.showWorkoutDetails(workoutInstance))
                HapticManager.shared.triggerNotification(type: .success)
            }
        } catch {
            errorReceived(error, displayType: .alert)
        }
    }

    private func startWorkoutFromTemplate(_ template: WorkoutTemplate) {
        Task { @MainActor in
            do {
                if let workoutInstance = try await addWorkoutManager.addWorkout(from: template, savesLocation: savesLocation) {
                    onOutput?(.showWorkoutDetails(workoutInstance))
                    HapticManager.shared.triggerNotification(type: .success)
                }
            } catch {
                errorReceived(error, displayType: .alert)
            }
        }
    }

    private func deleteWorkout(_ workout: WorkoutInstance) {
        workoutsProvider.delete(with: workout.id)
    }
}

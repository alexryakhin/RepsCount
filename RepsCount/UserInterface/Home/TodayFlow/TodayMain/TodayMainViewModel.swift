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
        case startRun
        case showRunDetails(RunInstance)
    }

    enum Output {
        case showWorkoutDetails(WorkoutInstance)
        case showAllWorkouts
        case showAllExercises
        case showRunDetails(RunInstance)
    }

    let output = PassthroughSubject<Output, Never>()

    @Published var isShowingAddWorkoutFromTemplate: Bool = false
    @Published private(set) var currentDate = Date.now
    @Published private(set) var plannedWorkouts: [WorkoutEvent] = []
    @Published private(set) var todayWorkouts: [WorkoutInstance] = []
    @Published private(set) var workoutTemplates: [WorkoutTemplate] = []
    @Published private(set) var recoveryScore: Int = 85
    @Published private(set) var dailyStrain: Int = 65
    @Published private(set) var recentRuns: [RunInstance] = []
    
    // New properties for enhanced dashboard
    @Published private(set) var sleepScore: Int = 72
    @Published private(set) var stressCurrent: Int = 28
    @Published private(set) var stressHighest: Int = 95
    @Published private(set) var stressLowest: Int = 6
    @Published private(set) var stressAverage: Int = 30
    @Published private(set) var stressLevel: String = "Low"
    @Published private(set) var energyLevel: Int = 60

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
        // Load mock recovery and strain data
        loadMockRecoveryData()
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
        case .startRun:
            // Mock run creation
            let mockRun = RunInstance(
                id: UUID(),
                date: Date(),
                distance: 0.0,
                duration: 0,
                pace: 0.0,
                heartRate: 0,
                type: .simple
            )
            output.send(.showRunDetails(mockRun))
        case .showRunDetails(let run):
            output.send(.showRunDetails(run))
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
    
    private func loadMockRecoveryData() {
        // Mock recovery and strain data
        recoveryScore = Int.random(in: 70...95)
        dailyStrain = Int.random(in: 40...80)
        sleepScore = Int.random(in: 60...85)
        
        // Mock stress data
        stressCurrent = Int.random(in: 20...40)
        stressHighest = Int.random(in: 80...100)
        stressLowest = Int.random(in: 5...15)
        stressAverage = Int.random(in: 25...45)
        stressLevel = stressCurrent < 30 ? "Low" : stressCurrent < 60 ? "Medium" : "High"
        energyLevel = Int.random(in: 50...80)
        
        // Mock recent runs
        recentRuns = [
            RunInstance(id: UUID(), date: Date().addingTimeInterval(-86400), distance: 5.2, duration: 1800, pace: 5.8, heartRate: 145, type: .simple),
            RunInstance(id: UUID(), date: Date().addingTimeInterval(-172800), distance: 3.1, duration: 1200, pace: 6.2, heartRate: 135, type: .simple)
        ]
    }
}

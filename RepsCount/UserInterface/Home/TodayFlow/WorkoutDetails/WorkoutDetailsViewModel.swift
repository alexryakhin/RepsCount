import Combine
import SwiftUI

final class WorkoutDetailsViewModel: BaseViewModel {

    enum Input {
        case markAsComplete
        case showAddExercise
        case showExerciseDetails(Exercise)
        case showDeleteExerciseAlert(Exercise)
        case showDeleteWorkoutAlert
        case renameWorkout
        case updateName(String)
        case addExercise(WorkoutTemplateExercise)
    }

    enum Output {
        case showExerciseDetails(Exercise)
        case finish
    }

    let output = PassthroughSubject<Output, Never>()

    @AppStorage(UDKeys.savesLocation) var savesLocation: Bool = true

    @Published var isShowingAlertToRenameWorkout: Bool = false
    @Published var nameInput: String = ""
    @Published var isShowingAddExerciseSheet: Bool = false
    @Published private(set) var workout: WorkoutInstance

    // MARK: - Private Properties

    private let workoutDetailsManager: WorkoutDetailsManagerInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(workout: WorkoutInstance) {
        self.workout = workout
        self.workoutDetailsManager = ServiceManager.shared.createWorkoutDetailsManager(workoutID: workout.id)
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .markAsComplete:
            showAlert(
                withModel: .init(
                    title: Loc.WorkoutDetails.markAsComplete.localized,
                    message: Loc.WorkoutDetails.markAsCompleteMessage.localized,
                    actionText: Loc.Common.cancel.localized,
                    destructiveActionText: Loc.Common.proceed.localized,
                    action: {
                        AnalyticsService.shared.logEvent(.workoutDetailsMarkAsCompleteCancelTapped)
                    },
                    destructiveAction: { [weak self] in
                        self?.workoutDetailsManager.markAsComplete()
                        AnalyticsService.shared.logEvent(.workoutDetailsMarkAsCompleteProceedTapped)
                    }
                )
            )
        case .showAddExercise:
            isShowingAddExerciseSheet.toggle()
        case .showExerciseDetails(let exercise):
            output.send(.showExerciseDetails(exercise))
        case .showDeleteExerciseAlert(let exercise):
            showAlert(
                withModel: .init(
                    title: Loc.WorkoutDetails.deleteExercise.localized,
                    message: Loc.WorkoutDetails.deleteExerciseMessage.localized,
                    actionText: Loc.Common.cancel.localized,
                    destructiveActionText: Loc.Common.delete.localized,
                    action: {
                        AnalyticsService.shared.logEvent(.workoutDetailsExerciseRemoveCancelButtonTapped)
                    },
                    destructiveAction: { [weak self, exercise] in
                        self?.deleteExercise(exercise)
                        AnalyticsService.shared.logEvent(.workoutDetailsExerciseRemoved)
                    }
                )
            )
        case .showDeleteWorkoutAlert:
            showAlert(
                withModel: .init(
                    title: Loc.WorkoutDetails.deleteWorkout.localized,
                    message: Loc.WorkoutDetails.deleteWorkoutMessage.localized,
                    actionText: Loc.Common.cancel.localized,
                    destructiveActionText: Loc.Common.delete.localized,
                    action: {
                        AnalyticsService.shared.logEvent(.workoutDetailsDeleteWorkoutCancelTapped)
                    },
                    destructiveAction: { [weak self] in
                        self?.deleteWorkout()
                        AnalyticsService.shared.logEvent(.workoutDetailsDeleteWorkoutActionTapped)
                    }
                )
            )
        case .renameWorkout:
            isShowingAlertToRenameWorkout.toggle()
        case .updateName(let name):
            workoutDetailsManager.updateName(name)
        case .addExercise(let exerciseTemplate):
            workoutDetailsManager.addExercise(exerciseTemplate, savesLocation: savesLocation)
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        workoutDetailsManager.workoutPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] workout in
                self?.workout = workout
                self?.nameInput = workout.name.orEmpty
            }
            .store(in: &cancellables)

        workoutDetailsManager.errorPublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
    }

    private func deleteWorkout() {
        workoutDetailsManager.deleteWorkout()
        output.send(.finish)
    }

    private func deleteExercise(_ exercise: Exercise) {
        workoutDetailsManager.deleteExercise(exercise)
    }
}

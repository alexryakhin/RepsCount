import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine

public final class WorkoutDetailsViewModel: DefaultPageViewModel {

    enum Input {
        case markAsComplete
        case showAddExercise
        case showExerciseDetails(Exercise)
        case showDeleteExerciseAlert(Exercise)
        case showDeleteWorkoutAlert
    }

    enum Output {
        case showExerciseDetails(Exercise)
        case finish
    }

    var onOutput: ((Output) -> Void)?

    @Published var isShowingAddExerciseSheet: Bool = false
    @Published private(set) var workout: WorkoutInstance

    // MARK: - Private Properties

    private let workoutDetailsManager: WorkoutDetailsManagerInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        workout: WorkoutInstance,
        workoutDetailsManager: WorkoutDetailsManagerInterface
    ) {
        self.workout = workout
        self.workoutDetailsManager = workoutDetailsManager
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .markAsComplete:
            showAlert(
                withModel: .init(
                    title: "Mark as complete",
                    message: "Are you sure you want to complete this workout? You won't be able to make any changes afterwards",
                    actionText: "Cancel",
                    destructiveActionText: "Proceed",
                    action: {/* Cancel action, do nothing */},
                    destructiveAction: { [weak self] in
                        self?.workoutDetailsManager.markAsComplete()
                    }
                )
            )
        case .showAddExercise:
            isShowingAddExerciseSheet.toggle()
        case .showExerciseDetails(let exercise):
            onOutput?(.showExerciseDetails(exercise))
        case .showDeleteExerciseAlert(let exercise):
            showAlert(
                withModel: .init(
                    title: "Delete exercise",
                    message: "Are you sure you want to delete this exercise?",
                    actionText: "Cancel",
                    destructiveActionText: "Delete",
                    action: {/* Cancel action, do nothing */},
                    destructiveAction: { [weak self, exercise] in
                        self?.deleteExercise(exercise)
                    }
                )
            )
        case .showDeleteWorkoutAlert:
            showAlert(
                withModel: .init(
                    title: "Delete workout",
                    message: "Are you sure you want to delete this workout?",
                    actionText: "Cancel",
                    destructiveActionText: "Delete",
                    action: {/* Cancel action, do nothing */},
                    destructiveAction: { [weak self] in
                        self?.deleteWorkout()
                    }
                )
            )
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        workoutDetailsManager.workoutPublisher
            .ifNotNil()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] workout in
                self?.workout = workout
            }
            .store(in: &cancellables)

        workoutDetailsManager.errorPublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] error in
                self?.errorReceived(error, displayType: .alert)
            }
            .store(in: &cancellables)
    }

    private func deleteWorkout() {
        workoutDetailsManager.deleteWorkout()
        onOutput?(.finish)
    }

    private func deleteExercise(_ exercise: Exercise) {
        workoutDetailsManager.deleteExercise(exercise)
    }
}

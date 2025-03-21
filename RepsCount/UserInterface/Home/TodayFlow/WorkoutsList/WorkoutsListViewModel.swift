import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine

public final class WorkoutsListViewModel: DefaultPageViewModel {

    enum Input {
        case showWorkoutDetails(WorkoutInstance)
        case deleteWorkout(WorkoutInstance)
    }

    enum Output {
        case showWorkoutDetails(WorkoutInstance)
    }

    var onOutput: ((Output) -> Void)?

    @Published private(set) var sections: [WorkoutsListContentView.ListSection] = []
    @Published var selectedDate: Date? {
        didSet {
            HapticManager.shared.triggerSelection()
        }
    }

    // MARK: - Private Properties

    private let workoutsProvider: WorkoutsProviderInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(workoutsProvider: WorkoutsProviderInterface) {
        self.workoutsProvider = workoutsProvider
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .showWorkoutDetails(let workout):
            onOutput?(.showWorkoutDetails(workout))
        case .deleteWorkout(let workout):
            deleteWorkout(workout.id)
        }
    }

    private func deleteWorkout(_ id: String) {
        workoutsProvider.delete(with: id)
    }

    private func setupBindings() {
        workoutsProvider.workoutsPublisher
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] workouts in
                if workouts.isNotEmpty {
                    self?.prepareWorkoutsForDisplay(workouts)
                    self?.resetAdditionalState()
                } else {
                    self?.additionalState = .placeholder()
                }
            }
            .store(in: &cancellables)
    }

    private func prepareWorkoutsForDisplay(_ workouts: [WorkoutInstance]) {
        Task { [weak self] in
            let groupedExercises = Dictionary(grouping: workouts, by: { workout in
                workout.date.startOfDay
            })
                .sorted(by: { $0.key > $1.key })
                .map { key, value in
                    WorkoutsListContentView.ListSection(
                        date: key,
                        title: key.formatted(date: .complete, time: .omitted),
                        items: value
                    )
                }

            await MainActor.run { [weak self, groupedExercises] in
                self?.sections = groupedExercises
            }
        }
    }
}

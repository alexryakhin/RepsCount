import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine

public final class PlanningMainViewModel: DefaultPageViewModel {

    enum Input {
        case createWorkoutTemplate
        case showWorkoutTemplateDetails(WorkoutTemplate)
        case deleteWorkoutTemplate(offsets: IndexSet)
        case showCalendar
    }

    enum Output {
        case createWorkoutTemplate
        case editWorkoutTemplate(WorkoutTemplate)
        case showCalendar
    }

    var onOutput: ((Output) -> Void)?

    @Published private(set) var workoutTemplates: [WorkoutTemplate] = []

    // MARK: - Private Properties

    private let workoutTemplatesProvider: WorkoutTemplatesProviderInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(workoutTemplatesProvider: WorkoutTemplatesProviderInterface) {
        self.workoutTemplatesProvider = workoutTemplatesProvider
        super.init()
        setupBindings()
        additionalState = .loading()
    }

    func handle(_ input: Input) {
        switch input {
        case .createWorkoutTemplate:
            onOutput?(.createWorkoutTemplate)
        case .showWorkoutTemplateDetails(let template):
            onOutput?(.editWorkoutTemplate(template))
        case .deleteWorkoutTemplate(let offsets):
            deleteElements(at: offsets)
        case .showCalendar:
            onOutput?(.showCalendar)
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        workoutTemplatesProvider.templatesPublisher
            .dropFirst()
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] templates in
                if templates.isNotEmpty {
                    self?.workoutTemplates = templates
                    self?.resetAdditionalState()
                } else {
                    self?.additionalState = .placeholder()
                }
            }
            .store(in: &cancellables)
    }

    private func deleteElements(at indices: IndexSet) {
        indices.map { workoutTemplates[$0] }
            .forEach { [weak self] in
                self?.deleteWorkoutTemplate($0.id)
            }
    }

    private func deleteWorkoutTemplate(_ id: String) {
        workoutTemplatesProvider.delete(with: id)
    }
}

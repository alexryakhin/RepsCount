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
        case deleteWorkoutTemplate(WorkoutTemplate)
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
        case .deleteWorkoutTemplate(let template):
            workoutTemplatesProvider.delete(with: template.id)
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
}

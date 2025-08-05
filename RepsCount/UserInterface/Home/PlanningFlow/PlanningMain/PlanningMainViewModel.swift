import Combine
import Foundation

final class PlanningMainViewModel: BaseViewModel {

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

    let output = PassthroughSubject<Output, Never>()

    @Published private(set) var workoutTemplates: [WorkoutTemplate] = []

    // MARK: - Private Properties

    private let workoutTemplatesProvider: WorkoutTemplatesProviderInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    override init() {
        self.workoutTemplatesProvider = ServiceManager.shared.workoutTemplatesProvider
        super.init()
        setupBindings()
        additionalState = .loading
    }

    func handle(_ input: Input) {
        switch input {
        case .createWorkoutTemplate:
            output.send(.createWorkoutTemplate)
        case .showWorkoutTemplateDetails(let template):
            output.send(.editWorkoutTemplate(template))
        case .deleteWorkoutTemplate(let template):
            workoutTemplatesProvider.delete(with: template.id)
        case .showCalendar:
            output.send(.showCalendar)
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        workoutTemplatesProvider.templatesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] templates in
                if templates.isNotEmpty {
                    self?.workoutTemplates = templates
                    self?.resetAdditionalState()
                } else {
                    self?.showPlaceholder(title: Loc.Planning.noTemplates.localized, subtitle: Loc.Planning.noTemplatesDescription.localized)
                }
            }
            .store(in: &cancellables)
    }
}

import UIKit
import SwiftUI

final class PlanningMainViewController: PageViewController<PlanningMainContentView>, NavigationBarVisible {

    enum Event {
        case createWorkoutTemplate
        case editWorkoutTemplate(WorkoutTemplate)
        case showCalendar
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: PlanningMainViewModel

    // MARK: - Initialization

    init(viewModel: PlanningMainViewModel) {
        self.viewModel = viewModel
        super.init(rootView: PlanningMainContentView(viewModel: viewModel))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func setup() {
        super.setup()
        setupBindings()
        setupNavigationBar()
        tabBarItem = TabBarItem.planning.item
        navigationItem.title = TabBarItem.planning.localizedTitle
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .createWorkoutTemplate:
                self?.onEvent?(.createWorkoutTemplate)
            case .editWorkoutTemplate(let template):
                self?.onEvent?(.editWorkoutTemplate(template))
            case .showCalendar:
                self?.onEvent?(.showCalendar)
            }
        }
    }
}

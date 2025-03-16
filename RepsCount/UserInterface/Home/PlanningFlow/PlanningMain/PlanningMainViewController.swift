import UIKit
import SwiftUI
import CoreUserInterface
import Core

public final class PlanningMainViewController: PageViewController<PlanningMainContentView> {

    public enum Event {
        case createWorkoutTemplate
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: PlanningMainViewModel

    // MARK: - Initialization

    public init(viewModel: PlanningMainViewModel) {
        self.viewModel = viewModel
        super.init(rootView: PlanningMainContentView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        setupBindings()
        tabBarItem = TabBarItem.planning.item
        navigationItem.title = TabBarItem.planning.localizedTitle
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .createWorkoutTemplate:
                self?.onEvent?(.createWorkoutTemplate)
            }
        }
    }
}

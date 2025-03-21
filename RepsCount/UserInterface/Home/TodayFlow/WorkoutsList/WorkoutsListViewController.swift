import UIKit
import SwiftUI
import CoreUserInterface
import Core

public final class WorkoutsListViewController: PageViewController<WorkoutsListContentView>, NavigationBarVisible {

    public enum Event {
        case showWorkoutDetails(WorkoutInstance)
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: WorkoutsListViewModel

    // MARK: - Initialization

    public init(viewModel: WorkoutsListViewModel) {
        self.viewModel = viewModel
        super.init(rootView: WorkoutsListContentView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        setupBindings()
        navigationItem.title = "Workouts"
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .showWorkoutDetails(let workout):
                self?.onEvent?(.showWorkoutDetails(workout))
            }
        }
    }
}

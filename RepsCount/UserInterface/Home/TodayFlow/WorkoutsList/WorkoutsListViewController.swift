import UIKit
import SwiftUI

final class WorkoutsListViewController: PageViewController<WorkoutsListContentView>, NavigationBarVisible {

    enum Event {
        case showWorkoutDetails(WorkoutInstance)
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: WorkoutsListViewModel

    // MARK: - Initialization

    init(viewModel: WorkoutsListViewModel) {
        self.viewModel = viewModel
        super.init(rootView: WorkoutsListContentView(viewModel: viewModel))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        setupBindings()
        navigationItem.title = NSLocalizedString("Workouts", comment: .empty)
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

import UIKit
import SwiftUI

final class TodayMainViewController: PageViewController<TodayMainContentView>, NavigationBarHidden {

    enum Event {
        case showWorkoutDetails(WorkoutInstance)
        case showAllWorkouts
        case showAllExercises
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: TodayMainViewModel

    // MARK: - Initialization

    init(viewModel: TodayMainViewModel) {
        self.viewModel = viewModel
        super.init(rootView: TodayMainContentView(viewModel: viewModel))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        setupBindings()
        tabBarItem = TabBarItem.today.item
        navigationItem.title = TabBarItem.today.localizedTitle
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .showWorkoutDetails(let workout):
                self?.onEvent?(.showWorkoutDetails(workout))
            case .showAllWorkouts:
                self?.onEvent?(.showAllWorkouts)
            case .showAllExercises:
                self?.onEvent?(.showAllExercises)
            }
        }
    }
}

import UIKit
import SwiftUI

final class WorkoutDetailsViewController: PageViewController<WorkoutDetailsContentView>, NavigationBarVisible {

    enum Event {
        case finish
        case showExerciseDetails(Exercise)
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: WorkoutDetailsViewModel

    // MARK: - Initialization

    init(viewModel: WorkoutDetailsViewModel) {
        self.viewModel = viewModel
        super.init(rootView: WorkoutDetailsContentView(viewModel: viewModel))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        setupBindings()
        navigationItem.titleView = NavBarTitleView(
            title: viewModel.workout.defaultName,
            subtitle: viewModel.workout.date.formatted(date: .abbreviated, time: .shortened)
        )
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .finish:
                self?.onEvent?(.finish)
            case .showExerciseDetails(let exercise):
                self?.onEvent?(.showExerciseDetails(exercise))
            }
        }

        viewModel.$workout
            .receive(on: DispatchQueue.main)
            .sink { [weak self] workout in
                self?.navigationItem.titleView = NavBarTitleView(
                    title: workout.defaultName,
                    subtitle: workout.date.formatted(date: .abbreviated, time: .shortened)
                )
            }
            .store(in: &cancellables)
    }
}

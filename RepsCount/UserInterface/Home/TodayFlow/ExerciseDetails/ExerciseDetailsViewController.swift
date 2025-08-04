import UIKit
import SwiftUI

final class ExerciseDetailsViewController: PageViewController<ExerciseDetailsContentView>, NavigationBarVisible {

    enum Event {
        case finish
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: ExerciseDetailsViewModel

    // MARK: - Initialization

    init(viewModel: ExerciseDetailsViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ExerciseDetailsContentView(viewModel: viewModel))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        setupBindings()
        setupNavigationBar()
    }

    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.titleView = NavBarTitleView(
            title: NSLocalizedString(viewModel.exercise.model.rawValue, comment: .empty),
            subtitle: viewModel.exercise.timestamp.formatted(date: .abbreviated, time: .shortened)
        )
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .finish:
                self?.onEvent?(.finish)
            }
        }
    }
}

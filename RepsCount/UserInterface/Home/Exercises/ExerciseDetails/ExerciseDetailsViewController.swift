import UIKit
import SwiftUI
import CoreUserInterface
import Core

public final class ExerciseDetailsViewController: PageViewController<ExerciseDetailsContentView>, NavigationBarVisible {

    public enum Event {
        case finish
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: ExerciseDetailsViewModel

    // MARK: - Initialization

    public init(viewModel: ExerciseDetailsViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ExerciseDetailsContentView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        setupBindings()
        setupNavigationBar()
    }

    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
                // handle output
            }
        }
    }
}

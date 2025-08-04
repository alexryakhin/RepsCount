import UIKit
import SwiftUI

final class CreateWorkoutTemplateViewViewController: PageViewController<CreateWorkoutTemplateViewContentView>, NavigationBarVisible {

    enum Event {
        case finish
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: CreateWorkoutTemplateViewViewModel

    // MARK: - Initialization

    init(viewModel: CreateWorkoutTemplateViewViewModel) {
        self.viewModel = viewModel
        super.init(rootView: CreateWorkoutTemplateViewContentView(viewModel: viewModel))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        setupBindings()
        navigationItem.title = viewModel.isEditing 
        ? NSLocalizedString("Edit workout template", comment: .empty)
        : NSLocalizedString("New workout template", comment: .empty)
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .dismiss:
                self?.onEvent?(.finish)
            }
        }

        viewModel.$isEditing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEditing in
                self?.navigationItem.title = isEditing
                ? NSLocalizedString("Edit workout template", comment: .empty)
                : NSLocalizedString("New workout template", comment: .empty)
            }
            .store(in: &cancellables)
    }
}

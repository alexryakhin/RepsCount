import UIKit
import SwiftUI
import CoreUserInterface
import Core

public final class CreateWorkoutTemplateViewViewController: PageViewController<CreateWorkoutTemplateViewContentView>, NavigationBarVisible {

    public enum Event {
        case finish
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: CreateWorkoutTemplateViewViewModel

    // MARK: - Initialization

    public init(viewModel: CreateWorkoutTemplateViewViewModel) {
        self.viewModel = viewModel
        super.init(rootView: CreateWorkoutTemplateViewContentView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
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
    }
}

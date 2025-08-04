import UIKit
import SwiftUI

final class AboutAppViewController: PageViewController<AboutAppContentView>, NavigationBarVisible {

    enum Event {
        case finish
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: AboutAppViewModel

    // MARK: - Initialization

    init(viewModel: AboutAppViewModel) {
        self.viewModel = viewModel
        super.init(rootView: AboutAppContentView(viewModel: viewModel))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        setupBindings()
        navigationItem.title = NSLocalizedString("About app", comment: .empty)
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

import UIKit
import SwiftUI

final class SettingsViewController: PageViewController<SettingsContentView>, NavigationBarVisible {

    enum Event {
        case showAboutApp
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: SettingsViewModel

    // MARK: - Initialization

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(rootView: SettingsContentView(viewModel: viewModel))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func setup() {
        super.setup()
        setupBindings()
        setupNavigationBar()
        tabBarItem = TabBarItem.settings.item
        navigationItem.title = TabBarItem.settings.localizedTitle
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .showAboutApp:
                self?.onEvent?(.showAboutApp)
            }
        }
    }
}

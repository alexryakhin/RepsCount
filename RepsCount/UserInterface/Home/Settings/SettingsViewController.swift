import UIKit
import SwiftUI
import CoreUserInterface
import Core

public final class SettingsViewController: PageViewController<SettingsContentView>, NavigationBarVisible {

    public enum Event {
        case showAboutApp
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: SettingsViewModel

    // MARK: - Initialization

    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(rootView: SettingsContentView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override public func setup() {
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

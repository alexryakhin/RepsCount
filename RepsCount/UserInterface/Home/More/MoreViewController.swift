import UIKit
import SwiftUI
import CoreUserInterface
import Core

public final class MoreViewController: PageViewController<MoreContentView>, NavigationBarVisible {

    public enum Event {
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: MoreViewModel

    // MARK: - Initialization

    public init(viewModel: MoreViewModel) {
        self.viewModel = viewModel
        super.init(rootView: MoreContentView(viewModel: viewModel))
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
        tabBarItem = TabBarItem.more.item
        navigationItem.title = TabBarItem.more.localizedTitle
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
                // handle output
            }
        }
    }
}

import UIKit
import SwiftUI
import CoreUserInterface
import Core

public final class TodayMainViewController: PageViewController<TodayMainContentView> {

    public enum Event {
        case finish
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: TodayMainViewModel

    // MARK: - Initialization

    public init(viewModel: TodayMainViewModel) {
        self.viewModel = viewModel
        super.init(rootView: TodayMainContentView(viewModel: viewModel))
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
        tabBarItem = TabBarItem.today.item
        navigationItem.title = TabBarItem.today.localizedTitle

        
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

import UIKit
import SwiftUI
import CoreUserInterface
import Core

public final class CalendarViewController: PageViewController<CalendarContentView>, NavigationBarVisible {

    public enum Event {
        case finish
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: CalendarViewModel

    // MARK: - Initialization

    public init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(rootView: CalendarContentView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        setupBindings()
        navigationItem.title = "Calendar"
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

import Swinject
import SwinjectAutoregistration
import UIKit

final class SettingsCoordinator: Coordinator {

    enum Event {
        case finish
    }

    // MARK: - Public Properties

    var onEvent: ((Event) -> Void)?
    lazy var navController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
    }

    override func start() {
        showMainController()
    }

    // MARK: - Private Methods

    private func showMainController() {
        let controller = resolver ~> SettingsViewController.self
        controller.onEvent = { [weak self] event in
            switch event {
            case .showAboutApp:
                self?.showAboutApp()
            @unknown default:
                fatalError("Unhandled event: \(event)")
            }
        }
        navController.addChild(controller)
    }

    private func showAboutApp() {
        let controller = resolver ~> AboutAppViewController.self
        router.push(controller)
    }
}

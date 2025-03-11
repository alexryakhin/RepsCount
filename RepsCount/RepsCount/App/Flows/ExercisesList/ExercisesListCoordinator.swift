import Combine
import Swinject
import SwinjectAutoregistration
import CoreNavigation
import CoreUserInterface
import UIKit
import UserInterface
import Core

final class ExercisesListCoordinator: Coordinator {

    // MARK: - Public Properties

    lazy var navController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
        innerRouter = Router(rootController: navController)
    }

    override func start() {
        showMainController()
    }

    // MARK: - Private Methods

    private func showMainController() {
        let controller = resolver ~> ExercisesListViewController.self
        controller.onEvent = { [weak self] event in
            switch event {
            case .showAddExercise:
                self?.showAddExercise()
            @unknown default:
                fatalError("Unhandled event")
            }
        }
        navController.addChild(controller)
    }

    private func showAddExercise() {

    }
}

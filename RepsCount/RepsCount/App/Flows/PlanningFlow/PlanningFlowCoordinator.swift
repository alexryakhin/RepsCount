import Combine
import Swinject
import SwinjectAutoregistration
import CoreNavigation
import CoreUserInterface
import UIKit
import UserInterface
import Core

final class PlanningFlowCoordinator: Coordinator {

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
        let controller = resolver ~> PlanningMainViewController.self
        controller.onEvent = { [weak self] event in
            switch event {
            case .createWorkoutTemplate:
                self?.createWorkoutTemplate()
            @unknown default:
                fatalError("Unhandled event")
            }
        }
        navController.addChild(controller)
    }

    private func createWorkoutTemplate() {
        let controller = resolver ~> CreateWorkoutTemplateViewViewController.self
        router.push(controller)
    }
}

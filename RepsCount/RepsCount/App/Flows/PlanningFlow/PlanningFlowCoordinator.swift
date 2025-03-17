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
            case .editWorkoutTemplate(let template):
                self?.editWorkoutTemplate(with: template)
            case .showCalendar:
                self?.showCalendar()
            @unknown default:
                fatalError("Unhandled event")
            }
        }
        navController.addChild(controller)
    }

    private func createWorkoutTemplate() {
        let workoutTemplateId: String? = nil
        let controller = resolver.resolve(CreateWorkoutTemplateViewViewController.self, argument: workoutTemplateId)

        controller?.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.router.popToRootModule(animated: true)
            @unknown default:
                fatalError("Unhandled event")
            }
        }

        router.push(controller)
    }

    private func editWorkoutTemplate(with template: WorkoutTemplate) {
        let workoutTemplateId: String? = template.id
        let controller = resolver.resolve(CreateWorkoutTemplateViewViewController.self, argument: workoutTemplateId)

        controller?.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.router.popToRootModule(animated: true)
            @unknown default:
                fatalError("Unhandled event")
            }
        }

        router.push(controller)
    }

    private func showCalendar() {
        let controller = resolver.resolve(CalendarViewController.self)
        router.push(controller)
    }
}

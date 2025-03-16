import Swinject
import SwinjectAutoregistration
import UserInterface
import Core
import CoreUserInterface
import CoreNavigation
import Services

final class HomeCoordinator: Coordinator {

    required init(router: RouterInterface) {
        super.init(router: router)
    }

    override func start() {
        showTabController()
    }

    private func showTabController() {
        guard topController(ofType: TabController.self) == nil else { return }

        let todayFlowNavigationController = assignTodayFlowCoordinator()
        let planningFlowNavigationController = assignPlanningFlowCoordinator()
        let moreNavigationController = assignMoreCoordinator()

        let controller = resolver ~> TabController.self

        controller.controllers = [
            todayFlowNavigationController,
            planningFlowNavigationController,
            moreNavigationController
        ]

        router.setRootModule(controller)
    }

    private func assignTodayFlowCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: TodayFlowAssembly())

        // TodayFlow flow coordinator
        guard let todayFlowCoordinator = child(ofType: TodayFlowCoordinator.self)
                ?? resolver.resolve(TodayFlowCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate TodayFlowCoordinator") }
        todayFlowCoordinator.start()

        let todayFlowNavigationController = todayFlowCoordinator.navController

        if !contains(child: TodayFlowCoordinator.self) {
            addDependency(todayFlowCoordinator)
        }

        return todayFlowNavigationController
    }

    private func assignPlanningFlowCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: PlanningFlowAssembly())

        // PlanningFlow flow coordinator
        guard let planningFlowCoordinator = child(ofType: PlanningFlowCoordinator.self)
                ?? resolver.resolve(PlanningFlowCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate PlanningFlowCoordinator") }
        planningFlowCoordinator.start()

        let planningFlowNavigationController = planningFlowCoordinator.navController

        if !contains(child: PlanningFlowCoordinator.self) {
            addDependency(planningFlowCoordinator)
        }

        return planningFlowNavigationController
    }

    private func assignMoreCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: MoreAssembly())

        // QuizzesList flow coordinator
        guard let moreCoordinator = child(ofType: MoreCoordinator.self)
                ?? resolver.resolve(MoreCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate MoreCoordinator") }
        moreCoordinator.start()

        let moreNavigationController = moreCoordinator.navController

        if !contains(child: MoreCoordinator.self) {
            addDependency(moreCoordinator)
        }

        return moreNavigationController
    }
}

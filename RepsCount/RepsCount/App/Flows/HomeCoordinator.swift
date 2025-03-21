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
        let settingsNavigationController = assignSettingsCoordinator()

        let controller = resolver ~> TabController.self

        controller.controllers = [
            todayFlowNavigationController,
            planningFlowNavigationController,
            settingsNavigationController
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

    private func assignSettingsCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: SettingsAssembly())

        // QuizzesList flow coordinator
        guard let settingsCoordinator = child(ofType: SettingsCoordinator.self)
                ?? resolver.resolve(SettingsCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate SettingsCoordinator") }
        settingsCoordinator.start()

        let settingsNavigationController = settingsCoordinator.navController

        if !contains(child: SettingsCoordinator.self) {
            addDependency(settingsCoordinator)
        }

        return settingsNavigationController
    }
}

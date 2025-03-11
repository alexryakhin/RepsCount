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

        let exercisesListNavigationController = assignExercisesListCoordinator()
        let moreNavigationController = assignMoreCoordinator()

        let controller = resolver ~> TabController.self

        controller.controllers = [
            exercisesListNavigationController,
            moreNavigationController
        ]

        router.setRootModule(controller)
    }

    private func assignExercisesListCoordinator() -> NavigationController {
        DIContainer.shared.assemble(assembly: ExercisesListAssembly())

        // ExercisesList flow coordinator
        guard let exercisesListCoordinator = child(ofType: ExercisesListCoordinator.self)
                ?? resolver.resolve(ExercisesListCoordinator.self, argument: router)
        else { fatalError("Unable to instantiate ExercisesListCoordinator") }
        exercisesListCoordinator.start()

        let exercisesListNavigationController = exercisesListCoordinator.navController

        if !contains(child: ExercisesListCoordinator.self) {
            addDependency(exercisesListCoordinator)
        }

        return exercisesListNavigationController
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

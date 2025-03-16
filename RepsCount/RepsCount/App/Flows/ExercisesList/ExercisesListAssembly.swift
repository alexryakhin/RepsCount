import Swinject
import SwinjectAutoregistration
import CoreNavigation
import UserInterface
import Services

final class ExercisesListAssembly: Assembly, Identifiable {

    var id: String = "ExercisesListAssembly"

    func assemble(container: Container) {
        container.autoregister(ExercisesListCoordinator.self, argument: RouterInterface.self, initializer: ExercisesListCoordinator.init)

        container.register(ExercisesListViewController.self) { resolver in
            let viewModel = ExercisesListViewModel(
                locationManager: resolver ~> LocationManagerInterface.self,
                exercisesProvider: resolver ~> ExercisesProviderInterface.self
            )
            let controller = ExercisesListViewController(viewModel: viewModel)
            return controller
        }

        container.register(ExerciseDetailsViewController.self) { resolver, exercise in
            let viewModel = ExerciseDetailsViewModel(
                exercise: exercise,
                exerciseDetailsManager: resolver.resolve(ExerciseDetailsManagerInterface.self, argument: exercise.id)!
            )
            let controller = ExerciseDetailsViewController(viewModel: viewModel)
            return controller
        }
    }
}

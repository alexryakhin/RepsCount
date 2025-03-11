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
            let viewModel = ExercisesListViewModel(arg: 0)
            let controller = ExercisesListViewController(viewModel: viewModel)
            return controller
        }
    }
}

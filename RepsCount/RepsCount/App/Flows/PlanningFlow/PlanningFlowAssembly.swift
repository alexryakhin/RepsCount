import Swinject
import SwinjectAutoregistration
import CoreNavigation
import UserInterface
import Services

final class PlanningFlowAssembly: Assembly, Identifiable {

    var id: String = "PlanningFlowAssembly"

    func assemble(container: Container) {
        container.autoregister(PlanningFlowCoordinator.self, argument: RouterInterface.self, initializer: PlanningFlowCoordinator.init)

        container.register(PlanningMainViewController.self) { resolver in
            let viewModel = PlanningMainViewModel(
                arg: 0
            )
            let controller = PlanningMainViewController(viewModel: viewModel)
            return controller
        }

        container.register(CreateWorkoutTemplateViewViewController.self) { resolver in
            let viewModel = CreateWorkoutTemplateViewViewModel(arg: 0)
            let controller = CreateWorkoutTemplateViewViewController(viewModel: viewModel)
            return controller
        }
    }
}

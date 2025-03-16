import Swinject
import SwinjectAutoregistration
import CoreNavigation
import UserInterface
import Services

final class TodayFlowAssembly: Assembly, Identifiable {

    var id: String = "TodayFlowAssembly"

    func assemble(container: Container) {
        container.autoregister(TodayFlowCoordinator.self, argument: RouterInterface.self, initializer: TodayFlowCoordinator.init)

        container.register(TodayMainViewController.self) { resolver in
            let viewModel = TodayMainViewModel(
                arg: 0
            )
            let controller = TodayMainViewController(viewModel: viewModel)
            return controller
        }
    }
}

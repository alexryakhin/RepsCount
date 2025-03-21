import Swinject
import SwinjectAutoregistration
import UserInterface
import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared

final class SettingsAssembly: Assembly, Identifiable {

    var id: String { "SettingsAssembly" }

    func assemble(container: Container) {
        container.autoregister(SettingsCoordinator.self, argument: RouterInterface.self, initializer: SettingsCoordinator.init)

        container.register(SettingsViewController.self) { resolver in
            let viewModel = SettingsViewModel(
                locationManager: resolver ~> LocationManagerInterface.self
            )
            let controller = SettingsViewController(viewModel: viewModel)
            return controller
        }

        container.register(AboutAppViewController.self) { resolver in
            let viewModel = AboutAppViewModel(arg: 0)
            let controller = AboutAppViewController(viewModel: viewModel)
            return controller
        }
    }

    func loaded(resolver: Resolver) {
        logInfo("Settings Assembly is loaded")
    }
}

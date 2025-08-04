//
//  Coordinator.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Swinject
import SwinjectAutoregistration
import UIKit

class Coordinator: BaseCoordinator, RoutableCoordinator {

    static let resolver: Resolver = DIContainer.shared.resolver
    let resolver: Resolver = DIContainer.shared.resolver

    let router: RouterInterface

    required init(router: RouterInterface) {
        self.router = router
    }

    open func topController<T>(ofType _: T.Type) -> T? {
        return lastController() as? T
    }

    open func lastController() -> UIViewController? {
        router.rootController?.viewControllers.last
    }
}

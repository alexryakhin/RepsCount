//
//  SceneDelegate.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/11/25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = BaseWindow(windowScene: windowScene)
        let diContainer = DIContainer.shared
        diContainer.assemble(assembly: ServicesAssembly())
        diContainer.assemble(assembly: AppAssembly(window: window))

        guard let appCoordinator = diContainer.resolver.resolve(AppCoordinator.self) else {
            fatalError("Failed to init AppCoordinator")
        }

        self.appCoordinator = appCoordinator

        appCoordinator.start()
    }
}

//
//  RepsCountApp.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI
import Swinject

@main
struct RepsCountApp: App {

    let resolver: Resolver

    init() {
        resolver = DIContainer.shared.resolver

        DIContainer.shared.assemble(assembly: ServiceAssembly())
        DIContainer.shared.assemble(assembly: UIAssembly())
    }

    var body: some Scene {
        WindowGroup {
            resolver.resolve(TabViewScreen.self)!
        }
    }
}

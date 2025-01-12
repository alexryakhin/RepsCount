//
//  AppContainer.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/12/25.
//

import Swinject
import SwiftUI

final class ServiceAssembly: Assembly, Identifiable {

    var id: String = "ServiceAssembly"

    func assemble(container: Container) {
        container.register(CoreDataServiceInterface.self) { _ in
            CoreDataService()
        }
        .inObjectScope(.container)

        container.register(LocationManagerInterface.self) { _ in
            LocationManager()
        }
        .inObjectScope(.container)

        container.register(ExerciseStorageInterface.self) { resolver in
            ExerciseStorage(
                coreDataService: resolver.resolve(CoreDataServiceInterface.self)!,
                locationManager: resolver.resolve(LocationManagerInterface.self)!
            )
        }
        .inObjectScope(.container)

        container.register(CalendarEventStorageInterface.self) { resolver in
            CalendarEventStorage(
                coreDataService: resolver.resolve(CoreDataServiceInterface.self)!
            )
        }
        .inObjectScope(.container)
    }
}

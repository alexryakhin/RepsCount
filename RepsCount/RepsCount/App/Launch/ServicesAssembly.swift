//
//  ServicesAssembly.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Swinject
import SwinjectAutoregistration
import Foundation
import Services
import Shared
import EventKit

final class ServicesAssembly: Assembly, Identifiable {

    let id = "ServicesAssembly"

    func assemble(container: Container) {

        container.register(JSONEncoder.self) { _ in
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .sortedKeys
            return encoder
        }.inObjectScope(.container)

        container.register(JSONDecoder.self) { _ in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                let formatter = DateFormatter()

                if let date = formatter.convertStringToDate(string: dateString, format: .iso) {
                    return date
                }
                if let date = formatter.convertStringToDate(string: dateString, formatString: "yyyy-MM-dd'T'HH:mm:ss'Z'") {
                    return date
                }
                if let date = formatter.convertStringToDate(string: dateString, formatString: "yyyy-MM-dd'T'HH:mm:ss") {
                    return date
                }
                if let date = formatter.convertStringToDate(string: dateString, formatString: "yyyy-MM-dd'T'HH:mm") {
                    return date
                }
                if let date = formatter.convertStringToDate(string: dateString, formatString: "yyyy-MM-dd") {
                    return date
                }
                if let date = formatter.convertStringToDate(string: String(dateString.prefix(10)), formatString: "yyyy-MM-dd") {
                    return date
                }
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            }
            return decoder
        }.inObjectScope(.container)

//        container.autoregister(FeatureToggleServiceInterface.self, initializer: FeatureToggleService.init)
//            .inObjectScope(.container)

        container.autoregister(EventDataStore.self, initializer: EventDataStore.init)
            .inObjectScope(.container)

        container.autoregister(EventStoreManagerInterface.self, initializer: EventStoreManager.init)
            .inObjectScope(.container)

        container.register(LocationManagerInterface.self) { resolver in
            LocationManager()
        }
        .inObjectScope(.container)

        container.register(CoreDataServiceInterface.self) { resolver in
            CoreDataService()
        }
        .inObjectScope(.container)

        container.register(ExercisesProviderInterface.self) { resolver in
            ExercisesProvider(
                coreDataService: resolver ~> CoreDataServiceInterface.self
            )
        }
        .inObjectScope(.container)

        container.register(AddExerciseManagerInterface.self) { resolver in
            AddExerciseManager(
                coreDataService: resolver ~> CoreDataServiceInterface.self,
                locationManager: resolver ~> LocationManagerInterface.self
            )
        }
        .inObjectScope(.transient)

        container.register(ExerciseDetailsManagerInterface.self) { resolver, exerciseID in
            ExerciseDetailsManager(
                exerciseID: exerciseID,
                coreDataService: resolver ~> CoreDataServiceInterface.self
            )
        }
        .inObjectScope(.transient)

        container.register(WorkoutTemplatesProviderInterface.self) { resolver in
            WorkoutTemplatesProvider(
                coreDataService: resolver ~> CoreDataServiceInterface.self
            )
        }
        .inObjectScope(.container)

        container.register(WorkoutEventsProviderInterface.self) { resolver in
            WorkoutEventsProvider(
                coreDataService: resolver ~> CoreDataServiceInterface.self
            )
        }
        .inObjectScope(.container)

        container.register(WorkoutsProviderInterface.self) { resolver in
            WorkoutsProvider(
                coreDataService: resolver ~> CoreDataServiceInterface.self
            )
        }
        .inObjectScope(.container)

        container.register(WorkoutTemplateManagerInterface.self) { resolver, workoutTemplateID in
            WorkoutTemplatesManager(
                workoutTemplateID: workoutTemplateID,
                coreDataService: resolver ~> CoreDataServiceInterface.self
            )
        }
        .inObjectScope(.transient)

        container.register(WorkoutEventManagerInterface.self) { resolver in
            WorkoutEventManager(
                coreDataService: resolver ~> CoreDataServiceInterface.self
            )
        }
        .inObjectScope(.transient)

        container.register(AddWorkoutManagerInterface.self) { resolver in
            AddWorkoutManager(
                coreDataService: resolver ~> CoreDataServiceInterface.self,
                locationManager: resolver ~> LocationManagerInterface.self
            )
        }
        .inObjectScope(.transient)

        container.register(WorkoutDetailsManagerInterface.self) { resolver, workoutID in
            WorkoutDetailsManager(
                workoutID: workoutID,
                coreDataService: resolver ~> CoreDataServiceInterface.self,
                locationManager: resolver ~> LocationManagerInterface.self
            )
        }
        .inObjectScope(.transient)
    }

    func loaded(resolver: Resolver) {
        logInfo("Services Assembly is loaded")
    }
}

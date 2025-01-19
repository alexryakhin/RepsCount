//
//  UIAssembly.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/12/25.
//

import Swinject
import SwiftUI

final class UIAssembly: Assembly, Identifiable {

    var id: String = "UIAssembly"

    func assemble(container: Container) {
        container.register(TabViewScreen.self) { _ in
            TabViewScreen()
        }

        container.register(ExercisesView.self) { resolver in
            let viewModel = ExercisesViewModel(
                exerciseStorage: resolver.resolve(ExerciseStorageInterface.self)!,
                locationManager: resolver.resolve(LocationManagerInterface.self)!
            )
            return ExercisesView(viewModel: viewModel)
        }

        container.register(AddExerciseView.self) { resolver, config in
            let viewModel = AddExerciseViewModel(
                exerciseStorage: resolver.resolve(ExerciseStorageInterface.self)!
            )
            return AddExerciseView(
                viewModel: viewModel,
                config: config
            )
        }

        container.register(ExerciseDetailsView.self) { resolver, exercise in
            let viewModel = ExerciseDetailsViewModel(
                exercise: exercise,
                coreDataService: resolver.resolve(CoreDataServiceInterface.self)!
            )
            return ExerciseDetailsView(viewModel: viewModel)
        }

        container.register(CalendarScreen.self) { resolver in
            return CalendarScreen()
        }

        container.register(SettingsView.self) { resolver in
            return SettingsView()
        }

        container.register(AboutAppView.self) { resolver in
            return AboutAppView()
        }

        container.register(EditExercisesScreen.self) { resolver in
            let viewModel = EditExercisesViewModel(
                exerciseStorage: resolver.resolve(ExerciseStorageInterface.self)!
            )
            return EditExercisesScreen(viewModel: viewModel)
        }

        container.register(PlanWorkoutScreen.self) { resolver in
            let viewModel = PlanWorkoutScreenViewModel(
                calendarEventStorage: resolver.resolve(CalendarEventStorageInterface.self)!
            )
            return PlanWorkoutScreen(viewModel: viewModel)
        }

        container.register(AddWorkoutExerciseView.self) { resolver, config in
            let viewModel = AddWorkoutExerciseViewModel(
                exerciseStorage: resolver.resolve(ExerciseStorageInterface.self)!
            )
            return AddWorkoutExerciseView(
                viewModel: viewModel,
                config: config
            )
        }
    }
}

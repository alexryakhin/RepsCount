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
                calendarEventsProvider: resolver ~> WorkoutEventsProviderInterface.self,
                addWorkoutManager: resolver ~> AddWorkoutManagerInterface.self,
                workoutsProvider: resolver ~> WorkoutsProviderInterface.self,
                workoutTemplatesProvider: resolver ~> WorkoutTemplatesProviderInterface.self,
                locationManager: resolver ~> LocationManagerInterface.self
            )
            let controller = TodayMainViewController(viewModel: viewModel)
            return controller
        }

        container.register(WorkoutDetailsViewController.self) { resolver, workoutInstance in
            let viewModel = WorkoutDetailsViewModel(
                workout: workoutInstance,
                workoutDetailsManager: resolver.resolve(WorkoutDetailsManagerInterface.self, argument: workoutInstance.id)!
            )
            let controller = WorkoutDetailsViewController(viewModel: viewModel)
            return controller
        }

        container.register(ExercisesListViewController.self) { resolver in
            let viewModel = ExercisesListViewModel(
                locationManager: resolver ~> LocationManagerInterface.self,
                exercisesProvider: resolver ~> ExercisesProviderInterface.self
            )
            let controller = ExercisesListViewController(viewModel: viewModel)
            return controller
        }

        container.register(ExerciseDetailsViewController.self) { resolver, exercise in
            let viewModel = ExerciseDetailsViewModel(
                exercise: exercise,
                exerciseDetailsManager: resolver.resolve(ExerciseDetailsManagerInterface.self, argument: exercise.id)!
            )
            let controller = ExerciseDetailsViewController(viewModel: viewModel)
            return controller
        }
    }
}

import Combine
import Swinject
import SwinjectAutoregistration
import CoreNavigation
import CoreUserInterface
import UIKit
import UserInterface
import Core

final class TodayFlowCoordinator: Coordinator {

    // MARK: - Public Properties

    lazy var navController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private var innerRouter: RouterInterface!

    // MARK: - Initialization

    required init(router: RouterInterface) {
        super.init(router: router)
        innerRouter = Router(rootController: navController)
    }

    override func start() {
        showMainController()
    }

    // MARK: - Private Methods

    private func showMainController() {
        let controller = resolver ~> TodayMainViewController.self
        controller.onEvent = { [weak self] event in
            switch event {
            case .showWorkoutDetails(let workout):
                self?.showWorkoutDetails(for: workout)
            case .showAllWorkouts:
                self?.showAllWorkouts()
            case .showAllExercises:
                self?.showAllExercises()
            @unknown default:
                fatalError("Unhandled event")
            }
        }
        navController.addChild(controller)
    }

    private func showAllExercises() {
        let controller = resolver ~> ExercisesListViewController.self
        controller.onEvent = { [weak self] event in
            switch event {
            case .showExerciseDetails(let exercise):
                self?.showExerciseDetails(for: exercise)
            @unknown default:
                fatalError("Unhandled event")
            }
        }
        router.push(controller)
    }

    private func showAllWorkouts() {
        let controller = resolver ~> WorkoutsListViewController.self
        controller.onEvent = { [weak self] event in
            switch event {
            case .showWorkoutDetails(let workout):
                self?.showWorkoutDetails(for: workout)
            @unknown default:
                fatalError("Unhandled event")
            }
        }
        router.push(controller)
    }

    private func showWorkoutDetails(for workout: WorkoutInstance) {
        let controller = resolver ~> (WorkoutDetailsViewController.self, workout)

        controller.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.router.popToRootModule(animated: true)
            case .showExerciseDetails(let exercise):
                self?.showExerciseDetails(for: exercise)
            @unknown default:
                fatalError("Unhandled event")
            }
        }

        router.push(controller)
    }

    private func showExerciseDetails(for exercise: Exercise) {
        let controller = resolver ~> (ExerciseDetailsViewController.self, exercise)

        controller.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.router.popModule(animated: true)
            @unknown default:
                fatalError("Unhandled event")
            }
        }

        router.push(controller)
    }
}

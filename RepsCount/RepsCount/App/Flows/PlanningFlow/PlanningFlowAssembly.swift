import Swinject
import SwinjectAutoregistration
import CoreNavigation
import UserInterface
import Services
import EventKit

final class PlanningFlowAssembly: Assembly, Identifiable {

    var id: String = "PlanningFlowAssembly"

    func assemble(container: Container) {
        container.autoregister(PlanningFlowCoordinator.self, argument: RouterInterface.self, initializer: PlanningFlowCoordinator.init)

        container.register(PlanningMainViewController.self) { resolver in
            let viewModel = PlanningMainViewModel(
                workoutTemplatesProvider: resolver ~> WorkoutTemplatesProviderInterface.self
            )
            let controller = PlanningMainViewController(viewModel: viewModel)
            return controller
        }

        container.register(CreateWorkoutTemplateViewViewController.self) { (resolver: Resolver, workoutTemplateId: String?) in
            let viewModel = CreateWorkoutTemplateViewViewModel(
                workoutTemplatesManager: resolver.resolve(WorkoutTemplateManagerInterface.self, argument: workoutTemplateId)!
            )
            let controller = CreateWorkoutTemplateViewViewController(viewModel: viewModel)
            return controller
        }

        container.register(CalendarViewController.self) { resolver in
            let viewModel = CalendarViewModel(
                calendarEventsProvider: resolver ~> CalendarEventsProviderInterface.self
            )
            let controller = CalendarViewController(viewModel: viewModel)
            return controller
        }

        container.register(ScheduleEventViewController.self) { (resolver: Resolver, eventId: String?) in
            let viewModel = ScheduleEventViewModel(
                calendarEventManager: resolver.resolve(CalendarEventManagerInterface.self, argument: eventId)!,
                workoutTemplatesProvider: resolver ~> WorkoutTemplatesProviderInterface.self,
                eventStoreManager: resolver ~> EventStoreManagerInterface.self
            )
            let controller = ScheduleEventViewController(viewModel: viewModel)
            return controller
        }
    }
}

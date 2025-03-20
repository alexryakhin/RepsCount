import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core

public struct PlanningMainContentView: PageView {

    public typealias ViewModel = PlanningMainViewModel

    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: PlanningMainViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        List {
            Section {
                Button {
                    viewModel.handle(.showCalendar)
                } label: {
                    Label {
                        VStack(alignment: .leading) {
                            Text("Schedule workouts")
                                .font(.headline)
                                .bold()
                                .foregroundStyle(.primary)
                            Text("Manage your workout schedule here: Create repetition for events, set reminders, and more.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
            } header: {
                Text("Calendar")
            }
            Section {
                ForEach(viewModel.workoutTemplates) { template in
                    Button(action: { viewModel.handle(.showWorkoutTemplateDetails(template)) }) {
                        WorkoutTemplateRow(template: template)
                    }
                }
                .onDelete {
                    viewModel.handle(.deleteWorkoutTemplate(offsets: $0))
                }
            } header: {
                Text("My workout templates")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { viewModel.handle(.createWorkoutTemplate) }) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyListView(label: "No Workouts Created", description: "You haven't created any workout templates yet.") {
            Button("Create New Workout Template") {
                viewModel.handle(.createWorkoutTemplate)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

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
        List(viewModel.workoutTemplates) { template in
            Button(action: { viewModel.handle(.showWorkoutTemplateDetails(template)) }) {
                WorkoutTemplateRow(template: template)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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

struct WorkoutTemplateRow: View {
    let template: WorkoutTemplate

    var body: some View {
        VStack(alignment: .leading) {
            Text(template.name)
                .font(.headline)
            Text("Exercises: \(template.templateExercises.count)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

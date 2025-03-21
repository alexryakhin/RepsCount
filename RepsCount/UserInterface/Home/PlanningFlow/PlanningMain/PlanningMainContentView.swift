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
        ScrollView {
            LazyVStack(spacing: 24) {
                calendarSectionView
                templatesSectionView
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .background(Color.background)
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

    private var calendarSectionView: some View {
        CustomSectionView(header: "Calendar") {
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .clippedWithPaddingAndBackground(.surface)
        }
    }

    private var templatesSectionView: some View {
        CustomSectionView(header: "My workout templates") {
            ForEach(viewModel.workoutTemplates) { template in
                Button {
                    viewModel.handle(.showWorkoutTemplateDetails(template))
                } label: {
                    WorkoutTemplateRow(template: template)
                        .clippedWithPaddingAndBackground(.surface)
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                viewModel.handle(.deleteWorkoutTemplate(template))
                            }
                        }
                }
            }
        }
    }
}

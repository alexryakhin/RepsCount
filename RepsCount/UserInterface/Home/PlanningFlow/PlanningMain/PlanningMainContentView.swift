import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core
import struct Services.AnalyticsService

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
                Button {
                    viewModel.handle(.createWorkoutTemplate)
                    AnalyticsService.shared.logEvent(.planningScreenAddTemplateMenuButtonTapped)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            AnalyticsService.shared.logEvent(.planningScreenOpened)
        }
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyListView(label: "No Workouts Created", description: "You haven't created any workout templates yet.") {
            Button("Create New Workout Template") {
                viewModel.handle(.createWorkoutTemplate)
                AnalyticsService.shared.logEvent(.planningScreenAddTemplateButtonTapped)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var calendarSectionView: some View {
        CustomSectionView(header: "Calendar") {
            Button {
                viewModel.handle(.showCalendar)
                AnalyticsService.shared.logEvent(.planningScreenCalendarTapped)
            } label: {
                Label {
                    VStack(alignment: .leading, spacing: 4) {
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
                    AnalyticsService.shared.logEvent(.planningScreenTemplateSelected)
                } label: {
                    WorkoutTemplateRow(template: template)
                        .clippedWithPaddingAndBackground(.surface)
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                viewModel.handle(.deleteWorkoutTemplate(template))
                                AnalyticsService.shared.logEvent(.planningScreenTemplateRemoved)
                            }
                        }
                }
            }
        }
    }
}

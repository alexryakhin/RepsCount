import SwiftUI

struct PlanningMainContentView: View {

    @ObservedObject var viewModel: PlanningMainViewModel

    init(viewModel: PlanningMainViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                calendarSectionView
                templatesSectionView
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(Loc.Navigation.planning.localized)
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
        .additionalState(viewModel.additionalState)
        .withAlertManager()
        .onAppear {
            AnalyticsService.shared.logEvent(.planningScreenOpened)
        }
    }



    private var calendarSectionView: some View {
        CustomSectionView(header: Loc.Navigation.calendar.localized) {
            Button {
                viewModel.handle(.showCalendar)
                AnalyticsService.shared.logEvent(.planningScreenCalendarTapped)
            } label: {
                Label {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Loc.Planning.scheduleWorkouts.localized)
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.primary)
                        Text(Loc.Planning.scheduleWorkoutsDescription.localized)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "calendar")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .clippedWithPaddingAndBackground()
        }
    }

    private var templatesSectionView: some View {
        CustomSectionView(header: Loc.Planning.myWorkoutTemplates.localized) {
            ForEach(viewModel.workoutTemplates) { template in
                Button {
                    viewModel.handle(.showWorkoutTemplateDetails(template))
                    AnalyticsService.shared.logEvent(.planningScreenTemplateSelected)
                } label: {
                    SwipeToDeleteView {
                        WorkoutTemplateRow(template: template)
                            .padding(vertical: 12, horizontal: 16)
                    } onDelete: {
                        viewModel.handle(.deleteWorkoutTemplate(template))
                        AnalyticsService.shared.logEvent(.planningScreenTemplateRemoved)
                    }
                    .clippedWithBackground()
                }
            }
        }
    }
}

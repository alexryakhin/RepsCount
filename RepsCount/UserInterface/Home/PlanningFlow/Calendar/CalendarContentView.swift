import SwiftUI

struct CalendarContentView: View {

    @ObservedObject var viewModel: CalendarViewModel

    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                calendarSectionView
                plannedWorkoutsSectionView
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.handle(.scheduleWorkout)
                    AnalyticsService.shared.logEvent(.calendarScreenScheduleWorkoutMenuButtonTapped)
                } label: {
                    Image(systemName: "calendar.badge.plus")
                }
            }
        }
        .additionalState(viewModel.additionalState)
        .withAlertManager()
        .onAppear {
            AnalyticsService.shared.logEvent(.calendarScreenOpened)
        }
    }

    private var calendarSectionView: some View {
        CustomSectionView(header: "Select date") {
            DatePicker("Select date", selection: $viewModel.selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .clippedWithPaddingAndBackground()
        }
    }

    private var plannedWorkoutsSectionView: some View {
        CustomSectionView(header: "Planned workouts") {
            if viewModel.eventsForSelectedDate.isEmpty {
                EmptyListView(description: "No Workouts Scheduled", background: .clear) {
                    VStack(spacing: 10) {
                        Button("Schedule a Workout") {
                            viewModel.handle(.scheduleWorkout)
                            AnalyticsService.shared.logEvent(.calendarScreenScheduleWorkoutTapped)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .clippedWithPaddingAndBackground()
            } else {
                ListWithDivider(viewModel.eventsForSelectedDate) { event in
                    SwipeToDeleteView {
                        WorkoutEventRow(event: event)
                            .padding(vertical: 12, horizontal: 16)
                    } onDelete: {
                        viewModel.handle(.deleteEvent(event))
                        AnalyticsService.shared.logEvent(.calendarScreenEventRemoveButtonTapped)
                    }
                }
                .clippedWithBackground()
            }
        }
    }
}

import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core
import struct Services.AnalyticsService

public struct CalendarContentView: PageView {

    public typealias ViewModel = CalendarViewModel

    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                calendarSectionView
                plannedWorkoutsSectionView
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .background(Color.background)
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
        .onAppear {
            AnalyticsService.shared.logEvent(.calendarScreenOpened)
        }
    }

    private var calendarSectionView: some View {
        CustomSectionView(header: "Select date") {
            DatePicker("Select date", selection: $viewModel.selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .clippedWithPaddingAndBackground(.surface)
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
                .clippedWithPaddingAndBackground(.surface)
            } else {
                ListWithDivider(viewModel.eventsForSelectedDate) { event in
                    WorkoutEventRow(event: event)
                        .padding(vertical: 12, horizontal: 16)
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                viewModel.handle(.deleteEvent(event))
                                AnalyticsService.shared.logEvent(.calendarScreenEventRemoveButtonTapped)
                            }
                        }
                }
                .clippedWithBackground(.surface)
            }
        }
    }
}

import SwiftUI

struct CalendarContentView: View {

    @ObservedObject var viewModel: CalendarViewModel

    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                calendarSectionView
                plannedWorkoutsSectionView
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
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
        VStack(spacing: 16) {
            HStack {
                Text("Select date")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            DatePicker("Select date", selection: $viewModel.selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                )
        }
    }

    private var plannedWorkoutsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Planned workouts")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            if viewModel.eventsForSelectedDate.isEmpty {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "calendar.badge.plus")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(spacing: 8) {
                        Text("No Workouts Scheduled")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Schedule your first workout for this date")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(Loc.Calendar.scheduleWorkout.localized) {
                        viewModel.handle(.scheduleWorkout)
                        AnalyticsService.shared.logEvent(.calendarScreenScheduleWorkoutTapped)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                )
            } else {
                VStack(spacing: 8) {
                    ForEach(viewModel.eventsForSelectedDate) { event in
                        SwipeToDeleteView {
                            WorkoutEventRow(event: event)
                                .padding(vertical: 12, horizontal: 16)
                        } onDelete: {
                            viewModel.handle(.deleteEvent(event))
                            AnalyticsService.shared.logEvent(.calendarScreenEventRemoveButtonTapped)
                        }
                        .clippedWithBackground()
                    }
                }
            }
        }
    }
}

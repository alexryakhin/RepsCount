import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core

public struct CalendarContentView: PageView {

    public typealias ViewModel = CalendarViewModel

    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        List {
            Section {
                DatePicker("Select date", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            } header: {
                Text("Select date")
            }

            Section {
                if viewModel.filteredEvents.isEmpty {
                    EmptyListView(description: "No Workouts Scheduled") {
                        VStack(spacing: 10) {
                            Button("Schedule a Workout") {
                                viewModel.handle(.scheduleWorkout)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                } else {
                    ForEach(viewModel.filteredEvents) { event in
                        WorkoutEventRow(event: event)
                    }
                    .onDelete {
                        viewModel.handle(.deleteEvent(atOffsets: $0))
                    }
                }
            } header: {
                Text("Planned workouts")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { viewModel.handle(.scheduleWorkout) }) {
                    Image(systemName: "calendar.badge.plus")
                }
            }
        }
    }
}

struct WorkoutEventRow: View {
    let event: WorkoutEvent

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.headline)
            Text("Planned at: \(event.startAtDate, formatter: DateFormatter.shortTime)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

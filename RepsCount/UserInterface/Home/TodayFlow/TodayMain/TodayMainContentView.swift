import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core

public struct TodayMainContentView: PageView {

    public typealias ViewModel = TodayMainViewModel

    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: TodayMainViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        List(viewModel.todayWorkouts) { workout in
            Button(action: { viewModel.handle(.showWorkoutDetails(workout)) }) {
                WorkoutRow(workout: workout)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(Date().formatted(date: .long, time: .omitted)) // e.g., March 16
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    Text("Today")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyListView(label: "No Workout Planned", description: "You haven't planned any workouts for today.") {
            VStack(spacing: 10) {
                Button("Add Workout from Templates") {
                    viewModel.handle(.showWorkouts)
                }
                .buttonStyle(.borderedProminent)

                Button("Start a new workout") {
                    viewModel.handle(.createNewWorkout)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct WorkoutRow: View {
    let workout: WorkoutInstance

    var body: some View {
        VStack(alignment: .leading) {
            Text(workout.workoutTemplate.name)
                .font(.headline)
            Text("Planned at: \(workout.date, formatter: DateFormatter.shortTime)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if workout.isCompleted {
                Text("Completed ✅")
                    .font(.footnote)
                    .foregroundColor(.green)
            }
        }
    }
}

extension DateFormatter {
    static var shortTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

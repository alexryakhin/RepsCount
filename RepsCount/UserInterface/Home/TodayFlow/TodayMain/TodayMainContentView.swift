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
        ScrollViewWithCustomNavBar {
            LazyVStack {
                todayWorkoutsSectionView
                plannedWorkoutsSectionView
            }
            .padding(.horizontal, 16)
        } navigationBar: {
            VStack(alignment: .leading, spacing: 0) {
                Text(Date.now.formatted(date: .long, time: .omitted)) // e.g., March 16
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Text("Today")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(vertical: 12, horizontal: 16)
        }
        .background(Color.background)
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

    private var plannedWorkoutsSectionView: some View {
        Section {
            ForEach(viewModel.plannedWorkouts) { event in
                Button {
                    viewModel.handle(.startPlannedWorkout(event))
                } label: {
                    TodayWorkoutEventRow(event: event)
                        .clippedWithBackground(.surface)
                }
            }
        } header: {
            CustomSectionHeader(text: "Planned workouts")
        }
    }

    @ViewBuilder
    private var todayWorkoutsSectionView: some View {
        if viewModel.todayWorkouts.isNotEmpty {
            Section {
                ForEach(viewModel.todayWorkouts) { workout in
                    Button {
                        viewModel.handle(.showWorkoutDetails(workout))
                    } label: {
                        TodayWorkoutRow(workout: workout)
                            .clippedWithBackground(.surface)
                    }
                }
            } header: {
                CustomSectionHeader(text: "Current workouts")
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

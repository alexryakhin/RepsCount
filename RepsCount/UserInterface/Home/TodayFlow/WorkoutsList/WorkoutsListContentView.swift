import SwiftUI

struct WorkoutsListContentView: PageView {

    typealias ViewModel = WorkoutsListViewModel

    struct ListSection: Hashable {
        let date: Date
        let title: String
        let items: [WorkoutInstance]
    }

    @ObservedObject var viewModel: ViewModel

    init(viewModel: WorkoutsListViewModel) {
        self.viewModel = viewModel
    }

    var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                if viewModel.selectedDate == nil {
                    ForEach(viewModel.sections, id: \.date) { section in
                        sectionView(for: section)
                    }
                } else if let selectedDate = viewModel.selectedDate, let section = viewModel.sections.first(where: {
                    $0.date == selectedDate.startOfDay
                }) {
                    sectionView(for: section)
                }
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .background(Color(.systemGroupedBackground))
        .animation(.default, value: viewModel.sections)
        .overlay {
            if let selectedDate = viewModel.selectedDate,
               viewModel.sections.first(where: { $0.date == selectedDate.startOfDay }) == nil {
                EmptyListView(
                    label: "No workouts",
                    description: "No workouts for this date!"
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CustomDatePicker(
                    date: $viewModel.selectedDate,
                    minDate: nil,
                    maxDate: Date.now,
                    pickerMode: .date,
                    labelFont: .body
                )
                .onLongPressGesture {
                    HapticManager.shared.triggerSelection()
                    viewModel.selectedDate = nil
                }
            }
        }
        .animation(.easeIn, value: viewModel.selectedDate)
        .onAppear {
            AnalyticsService.shared.logEvent(.allWorkoutsScreenOpened)
        }
    }

    func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyListView(
            label: "No workouts yet",
            description: "Go back and start a workout"
        )
    }

    private func sectionView(for section: ListSection) -> some View {
        CustomSectionView(header: LocalizedStringKey(section.title)) {
            ListWithDivider(section.items) { workout in
                Button {
                    viewModel.handle(.showWorkoutDetails(workout))
                    AnalyticsService.shared.logEvent(.allWorkoutsScreenWorkoutSelected)
                } label: {
                    SwipeToDeleteView {
                        TodayWorkoutRow(workout: workout)
                            .padding(vertical: 12, horizontal: 16)
                    } onDelete: {
                        viewModel.handle(.deleteWorkout(workout))
                        AnalyticsService.shared.logEvent(.allWorkoutsScreenWorkoutRemoveButtonTapped)
                    }
                }
            }
            .clippedWithBackground()
        }
    }
}

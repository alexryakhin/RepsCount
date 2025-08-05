import SwiftUI

struct WorkoutsListContentView: View {

    struct ListSection: Hashable {
        let date: Date
        let title: String
        let items: [WorkoutInstance]
    }

    @ObservedObject var viewModel: WorkoutsListViewModel

    init(viewModel: WorkoutsListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
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
        .additionalState(viewModel.additionalState)
        .withAlertManager()
        .onAppear {
            AnalyticsService.shared.logEvent(.allWorkoutsScreenOpened)
        }
    }



    private func sectionView(for section: ListSection) -> some View {
                    CustomSectionView(header: section.title) {
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

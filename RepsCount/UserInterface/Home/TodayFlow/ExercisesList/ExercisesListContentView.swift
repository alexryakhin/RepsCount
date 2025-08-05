//
//  ExercisesListContentView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct ExercisesListContentView: View {

    struct ListSection: Hashable {
        let date: Date
        let title: String
        let items: [Exercise]
    }

    @ObservedObject var viewModel: ExercisesListViewModel

    init(viewModel: ExercisesListViewModel) {
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
                    label: "No exercises",
                    description: "No exercises for this date!"
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
            AnalyticsService.shared.logEvent(.allExercisesScreenOpened)
        }
    }



    private func sectionView(for section: ListSection) -> some View {
                    CustomSectionView(header: section.title) {
            ListWithDivider(section.items) { exercise in
                Button {
                    viewModel.handle(.showExerciseDetails(exercise))
                    AnalyticsService.shared.logEvent(.allExercisesScreenExerciseSelected)
                } label: {
                    SwipeToDeleteView {
                        ExerciseListCellView(exercise: exercise)
                            .padding(vertical: 12, horizontal: 16)
                    } onDelete: {
                        viewModel.handle(.deleteExercise(exercise))
                        AnalyticsService.shared.logEvent(.allExercisesScreenExerciseRemoveButtonTapped)
                    }
                }
            }
            .clippedWithBackground()
        }
    }
}

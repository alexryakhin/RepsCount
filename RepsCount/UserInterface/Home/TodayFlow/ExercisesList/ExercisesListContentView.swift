//
//  ExercisesListContentView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI
import CoreUserInterface
import Core
import struct Services.AnalyticsService

public struct ExercisesListContentView: PageView {

    public typealias ViewModel = ExercisesListViewModel

    struct ListSection: Hashable {
        let date: Date
        let title: String
        let items: [Exercise]
    }

    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
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
        .background(Color.background)
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
        .onAppear {
            AnalyticsService.shared.logEvent(.allExercisesScreenOpened)
        }
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyListView(
            label: "No exercises yet",
            description: "Go back and start a workout"
        )
    }

    private func sectionView(for section: ListSection) -> some View {
        CustomSectionView(header: LocalizedStringKey(section.title)) {
            ListWithDivider(section.items) { exercise in
                Button {
                    viewModel.handle(.showExerciseDetails(exercise))
                    AnalyticsService.shared.logEvent(.allExercisesScreenExerciseSelected)
                } label: {
                    ExerciseListCellView(
                        model: .init(
                            exercise: exercise.model.name,
                            categories: exercise.model.categoriesLocalizedNames
                        )
                    )
                }
                .padding(vertical: 12, horizontal: 16)
                .contextMenu {
                    Button("Delete", role: .destructive) {
                        viewModel.handle(.deleteExercise(exercise))
                        AnalyticsService.shared.logEvent(.allExercisesScreenExerciseRemoveButtonTapped)
                    }
                }
            }
            .clippedWithBackground(Color.surface)
        }
    }
}

//
//  ExercisesListContentView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI
import CoreUserInterface
import CoreNavigation
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
        List {
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
            }
        }
        .animation(.easeIn, value: viewModel.selectedDate)
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyListView(
            label: "No exercises yet",
            description: "Go back and start a workout"
        )
    }

    private func sectionView(for section: ListSection) -> some View {
        Section {
            ForEach(section.items) { exercise in
                Button {
                    viewModel.handle(.showExerciseDetails(exercise))
                } label: {
                    ExerciseListCellView(
                        model: .init(
                            exercise: exercise.model.name,
                            categories: exercise.model.categoriesLocalizedNames
                        )
                    )
                }
            }
            .onDelete { indexSet in
                viewModel.handle(.deleteElements(indices: indexSet, date: section.date))
            }
        } header: {
            Text(section.title)
        }
    }
}

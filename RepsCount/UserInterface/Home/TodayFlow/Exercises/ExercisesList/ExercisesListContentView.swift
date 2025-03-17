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
import StoreKit
import struct Services.AnalyticsService

public struct ExercisesListContentView: PageView {

    public typealias ViewModel = ExercisesListViewModel

    struct ListSection: Hashable {
        let date: Date
        let title: String
        let items: [Exercise]
    }

    @AppStorage(UDKeys.isShowingRating) var isShowingRating: Bool = true
    @AppStorage(UDKeys.isShowingOnboarding) var isShowingOnboarding: Bool = true
    @AppStorage(UDKeys.showsFiltersOnExerciseList) var showsFiltersOnExerciseList: Bool = true
    @Environment(\.requestReview) var requestReview
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
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            addExerciseButton
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.selectedDate != nil {
                    Button {
                        viewModel.selectedDate = nil
                    } label: {
                        Image(systemName: "calendar.badge.minus")
                    }
                    .tint(.red)
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                CustomDatePicker(
                    date: $viewModel.selectedDate,
                    minDate: nil,
                    maxDate: Date.now,
                    pickerMode: .date,
                    labelFont: .system(.body, weight: .bold)
                )
            }
        }
        .animation(.easeIn, value: viewModel.selectedDate)
        .sheet(isPresented: $isShowingOnboarding) {
            isShowingOnboarding = false
        } content: {
            OnboardingView()
        }
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyListView(
            label: "No exercises yet",
            description: "Begin to add exercises to your list by tapping on plus icon in bottom right corner"
        ) {
            Button("Add your first exercise!", action: addItem)
                .buttonStyle(.borderedProminent)
        }
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
                            categories: exercise.model.categoriesLocalizedNames,
                            dateFormatted: exercise.timestamp.formatted(date: .omitted, time: .shortened)
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

    private var addExerciseButton: some View {
        Button {
            addItem()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold, design: .monospaced))
                .padding(8)
        }
        .buttonStyle(.bordered)
        .padding(24)
    }

    private func addItem() {
//        if isShowingRating && viewModel.exercises.count > 15 {
//            requestReview()
//            isShowingRating = false
//        }
        viewModel.handle(.showAddExercise)
    }
}

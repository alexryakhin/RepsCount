//
//  ContentView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI
import CoreData

struct ExercisesView: View {
    private let resolver = DIContainer.shared.resolver
    @ObservedObject private var viewModel: ExercisesViewModel

    @State private var selectedNameFilter: String? = nil
    @State private var isChoosingExercise = false
    @State private var shouldNavigateToEditExercisesScreen = false
    @State private var dateSelection: Date?

    private var groupedExercises: [Date: [Exercise]] {
        Dictionary(grouping: viewModel.exercises, by: { exercise in
            // Use only the day component for grouping
            (exercise.timestamp ?? .now).trimmed()
        })
    }

    init(viewModel: ExercisesViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Group {
                if groupedExercises.isEmpty {
                    VStack {
                        Spacer()
                        RCContentUnavailableView(
                            title: "No exercises yet",
                            description: "Tap on a plus button to add a new exercise!",
                            systemImage: "figure.strengthtraining.functional"
                        )
                        Spacer()
                        HStack {
                            Spacer()
                            addExerciseButton
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    List {
                        if viewModel.sortedUniqueExerciseNames.count >= 2 {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.sortedUniqueExerciseNames, id: \.self) { name in
                                        nameFilterButtonView(for: name)
                                    }
                                }
                                .scrollTargetLayoutIfAvailable()
                            }
                            .scrollTargetBehaviorIfAvailable()
                            .listRowBackground(Color.clear)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowSpacing(0)
                            .listRowSeparator(.hidden, edges: .all)
                        }

                        if dateSelection == nil {
                            ForEach(groupedExercises.keys.sorted(by: >), id: \.self) { date in
                                sectionForDate(date)
                            }
                        } else if let dateSelection, let date = dateSelectionWithTimeOmitted(for: dateSelection) {
                            sectionForDate(date)
                        }
                    }
                    .animation(.default, value: viewModel.exercises)
                    .safeAreaInset(edge: .bottom, alignment: .trailing) {
                        addExerciseButton
                    }
                    .overlay {
                        if let dateSelection,
                           let date = dateSelectionWithTimeOmitted(for: dateSelection),
                           groupedExercises[date] == nil {
                            RCContentUnavailableView(
                                title: "No exercises",
                                description: "No exercises for this date!",
                                systemImage: "figure.strengthtraining.functional"
                            )
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if dateSelection != nil {
                        Button {
                            self.dateSelection = nil
                        } label: {
                            Image(systemName: "calendar.badge.minus")
                        }
                        .tint(.red)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    CustomDatePicker(
                        date: $dateSelection,
                        minDate: nil,
                        maxDate: Date.now,
                        pickerMode: .date,
                        labelFont: .system(.body, weight: .bold)
                    )
                }
            }
            .navigationTitle("Reps counter")
            .sheet(isPresented: $isChoosingExercise) {
                addExerciseView
            }
            .animation(.easeIn, value: dateSelection)
            .background {
                NavigationLink(
                    destination: resolver.resolve(EditExercisesScreen.self)!,
                    isActive: $shouldNavigateToEditExercisesScreen
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
    }

    @ViewBuilder
    private func sectionForDate(_ date: Date) -> some View {
        let exercisesInDate = (groupedExercises[date] ?? []).filter {
            if let selectedNameFilter {
                $0.name == selectedNameFilter
            } else {
                true
            }
        }
        if exercisesInDate.isEmpty == false {
            Section {
                ForEach(exercisesInDate) { exercise in
                    NavigationLink {
                        exerciseDetailsView(for: exercise)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey(exercise.name ?? ""))
                                .font(.headline)
                                .foregroundColor(.primary)
                            + Text(", ")
                            + Text(LocalizedStringKey(exercise.category ?? ""))
                            if let date = exercise.timestamp {
                                Text(date.formatted(date: .omitted, time: .shortened))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete { indices in
                    deleteElements(at: indices, for: date)
                }
            } header: {
                Text(date.formatted(date: .complete, time: .omitted))
            }
        }
    }

    @ViewBuilder
    private func nameFilterButtonView(for name: String) -> some View {
        if selectedNameFilter == name {
            Button {
                withAnimation {
                    selectedNameFilter = nil
                }
                HapticManager.shared.triggerSelection()
            } label: {
                Text(name)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(Capsule())
        } else {
            Button {
                withAnimation {
                    selectedNameFilter = name
                }
                HapticManager.shared.triggerSelection()
            } label: {
                Text(name)
            }
            .buttonStyle(.bordered)
            .clipShape(Capsule())
        }
    }

    private func deleteElements(at indices: IndexSet, for date: Date) {
        if let exercises = groupedExercises[date] {
            withAnimation {
                indices
                    .map { exercises[$0] }
                    .forEach { viewModel.deleteExercise($0) }
            }
        }
    }

    private func dateSelectionWithTimeOmitted(for date: Date) -> Date? {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return Calendar.current.date(from: components)
    }

    private var addExerciseButton: some View {
        Button {
            isChoosingExercise = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold, design: .monospaced))
                .padding(8)
        }
        .buttonStyle(.bordered)
        .padding(24)
    }

    @ViewBuilder
    private var addExerciseView: some View {
        let config = AddExerciseView.Config(
            isPresented: $isChoosingExercise,
            onGoToAddExerciseModel: {
                isChoosingExercise = false
                shouldNavigateToEditExercisesScreen = true
        })
        resolver.resolve(AddExerciseView.self, argument: config)!
    }

    @ViewBuilder
    private func exerciseDetailsView(for exercise: Exercise) -> some View {
        resolver.resolve(ExerciseDetailsView.self, argument: exercise)!
    }
}

#Preview {
    DIContainer.shared.resolver.resolve(ExercisesView.self)!
}

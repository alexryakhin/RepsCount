//
//  ContentView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI
import CoreData

struct ExercisesView: View {
    @AppStorage("savesLocation") var savesLocation: Bool = true
    @StateObject private var viewModel = ExercisesViewModel()

    @State private var isChoosingExercise = false
    @State private var dateSelection: Date?

    private var groupedExercises: [Date: [Exercise]] {
        Dictionary(grouping: viewModel.exercises, by: { exercise in
            // Use only the day component for grouping
            let components = Calendar.current.dateComponents([.year, .month, .day], from: exercise.timestamp ?? .now)
            return Calendar.current.date(from: components)!
        })
    }

    var body: some View {
        NavigationView {
            Group {
                if groupedExercises.isEmpty {
                    ContentUnavailableView(
                        "No exercises yet",
                        systemImage: "figure.strengthtraining.functional",
                        description: Text("Tap on a plus button to add a new exercise!")
                    )
                } else {
                    List {
                        if dateSelection == nil {
                            ForEach(groupedExercises.keys.sorted(by: >), id: \.self) { date in
                                sectionForDate(date)
                            }
                        } else if let dateSelection, let date = dateSelectionWithTimeOmitted(for: dateSelection) {
                            sectionForDate(date)
                        }
                    }
                    .overlay {
                        if let dateSelection,
                           let date = dateSelectionWithTimeOmitted(for: dateSelection),
                           groupedExercises[date] == nil {
                            ContentUnavailableView(
                                "No exercises",
                                systemImage: "figure.strengthtraining.functional",
                                description: Text("No exercises for this date!")
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
                    CustomDatePicker(date: $dateSelection, minDate: nil, maxDate: Date.now, pickerMode: .date)
                }
            }
            .navigationTitle("Reps counter")
            .sheet(isPresented: $isChoosingExercise, onDismiss: {
                withAnimation {
                    viewModel.fetchExercises()
                }
            }) {
                AddExerciseView(isPresented: $isChoosingExercise)
                    .presentationDetents([.height(310)])
                    .presentationDragIndicator(.visible)
            }
            .animation(.easeIn, value: dateSelection)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    isChoosingExercise = true
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .bold()
                        .padding(16)
                        .background(in: Circle())
                        .overlay {
                            Circle().strokeBorder()
                        }
                }
                .padding(30)
            }
        }
        .onAppear {
            if savesLocation {
                LocationManager.shared.initiateLocationManager()
            }
        }
    }

    @ViewBuilder
    private func sectionForDate(_ date: Date) -> some View {
        let exercisesInDate = groupedExercises[date] ?? []
        Section {
            ForEach(exercisesInDate) { exercise in
                NavigationLink {
                    ExerciseView(exerciseId: exercise.id ?? "")
                } label: {
                    VStack(alignment: .leading) {
                        Text(exercise.displayName)
                            .font(.headline)
                            .foregroundStyle(.primary)
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

    func deleteElements(at indices: IndexSet, for date: Date) {
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
}

#Preview {
    ExercisesView()
}

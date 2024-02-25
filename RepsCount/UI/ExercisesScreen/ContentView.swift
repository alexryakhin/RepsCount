//
//  ContentView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI
import CoreData
import StoreKit

struct ExercisesView: View {
    @Environment(\.requestReview) var requestReview
    @AppStorage("isReviewRequested") var isReviewRequested = false

    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("savesLocation") var savesLocation: Bool = true

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseSet.timestamp, ascending: false)],
        animation: .default
    )
    private var exercises: FetchedResults<Exercise>

    private var groupedExercises: [Date: [Exercise]] {
        Dictionary(grouping: exercises, by: { exercise in
            // Use only the day component for grouping
            let components = Calendar.current.dateComponents([.year, .month, .day], from: exercise.timestamp ?? .now)
            return Calendar.current.date(from: components)!
        })
    }

    @State private var isShowingAlert = false
    @State private var alertInput = ""
    @State private var dateSelection: Date?

    private func dateSelectionWithTimeOmitted(for date: Date) -> Date? {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return Calendar.current.date(from: components)
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
            .alert("Enter a exercise name", isPresented: $isShowingAlert) {
                TextField("Name", text: $alertInput)
                    .autocorrectionDisabled()
                Button("Cancel", role: .cancel) { }
                Button("Add") {
                    addItem()
                }
            }
            .animation(.easeIn, value: dateSelection)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    isShowingAlert = true
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
                        Text(exercise.name ?? "Default name")
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

    private func addItem() {
        guard !alertInput.isEmpty else { return }
        Task { @MainActor in
            let newItem = Exercise(context: viewContext)
            newItem.timestamp = .now
            newItem.name = alertInput
            newItem.id = UUID().uuidString
            if savesLocation, let location = await LocationManager.shared.getCurrentLocation() {
                newItem.latitude = location.latitude
                newItem.longitude = location.longitude
                newItem.address = location.address
                debugPrint(location)
            }
            withAnimation {
                save()
            }
            if exercises.count > 15, !isReviewRequested {
                isReviewRequested = true
                requestReview()
            }
            alertInput = ""
        }
    }

    func deleteElements(at indices: IndexSet, for date: Date) {
        if let exercises = groupedExercises[date] {
            withAnimation {
                indices
                    .map { exercises[$0] }
                    .forEach(viewContext.delete)
            }
        }
        save()
    }

    private func save() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    ExercisesView()
}

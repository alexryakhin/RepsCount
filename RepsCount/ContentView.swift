//
//  ContentView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutSet.timestamp, ascending: true)],
        animation: .default
    )
    private var workouts: FetchedResults<Workout>

    private var groupedWorkouts: [Date: [Workout]] {
        Dictionary(grouping: workouts, by: { workout in
            // Use only the day component for grouping
            let components = Calendar.current.dateComponents([.year, .month, .day], from: workout.timestamp ?? .now)
            return Calendar.current.date(from: components)!
        })
    }

    @State private var isShowingAlert = false
    @State private var alertInput = ""
    @State private var dateSelection = Date()

    private var dateSelectionWithTimeOmitted: Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: dateSelection)
        return Calendar.current.date(from: components)!
    }

    var body: some View {
        NavigationView {
            Group {
                if groupedWorkouts.isEmpty {
                    ContentUnavailableView(
                        "No workouts yet",
                        systemImage: "figure.strengthtraining.functional",
                        description: Text("Tap on a plus button to add a new exercise!")
                    )
                } else {
                    List {
                        if Calendar.current.isDateInToday(dateSelection) {
                            ForEach(groupedWorkouts.keys.sorted(by: >), id: \.self) { date in
                                sectionForDate(date)
                            }
                        } else {
                            sectionForDate(dateSelectionWithTimeOmitted)
                        }
                    }
                    .overlay {
                        if !Calendar.current.isDateInToday(dateSelection),
                            groupedWorkouts[dateSelectionWithTimeOmitted] == nil {
                            ContentUnavailableView(
                                "No workouts",
                                systemImage: "figure.strengthtraining.functional",
                                description: Text("No workouts for this date!")
                            )
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    DatePicker(selection: $dateSelection, in: ...Date.now, displayedComponents: .date) {
                        Text("Select a date")
                    }
                    .labelsHidden()
                }
            }
            .navigationTitle("Reps counter")
            .alert("Enter a workout name", isPresented: $isShowingAlert) {
                TextField("Name", text: $alertInput)
                    .autocorrectionDisabled()
                Button("Cancel", role: .cancel) { }
                Button("Add") {
                    addItem()
                }
            }
            .animation(.easeIn, value: dateSelection)
        }
        .onAppear {
            LocationManager.shared.initiateLocationManager()
        }
    }

    @ViewBuilder
    private func sectionForDate(_ date: Date) -> some View {
        let workoutsInDate = groupedWorkouts[date] ?? []
        Section {
            ForEach(workoutsInDate) { workout in
                NavigationLink {
                    WorkoutView(workoutId: workout.id ?? "")
                } label: {
                    VStack(alignment: .leading) {
                        Text(workout.name ?? "Default name")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        if let date = workout.timestamp {
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
            let newItem = Workout(context: viewContext)
            newItem.timestamp = .now
            newItem.name = alertInput
            newItem.id = UUID().uuidString
            if let location = await LocationManager.shared.getCurrentLocation() {
                newItem.latitude = location.latitude
                newItem.longitude = location.longitude
                newItem.address = location.address
                print(location)
            }
            withAnimation {
                save()
            }
            alertInput = ""
        }
    }

    func deleteElements(at indices: IndexSet, for date: Date) {
        if let workouts = groupedWorkouts[date] {
            withAnimation {
                indices
                    .map { workouts[$0] }
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

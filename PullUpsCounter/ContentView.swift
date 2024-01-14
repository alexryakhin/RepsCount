//
//  ContentView.swift
//  PullUpsCounter
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

    @State private var isShowingAlert = false
    @State private var alertInput = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(workouts) { workout in
                    NavigationLink {
                        WorkoutView(workoutId: workout.id ?? "")
                    } label: {
                        VStack(alignment: .leading) {
                            Text(workout.name ?? "Default name")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            if let date = workout.timestamp {
                                Text(date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        isShowingAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Workout reps counter")
            .alert("Enter a workout name", isPresented: $isShowingAlert) {
                TextField("Name", text: $alertInput)
                Button("Cancel", role: .cancel) { }
                Button("Add") {
                    addItem()
                }
            }
        }
    }

    private func addItem() {
        defer { alertInput = "" }
        guard !alertInput.isEmpty else { return }
        withAnimation {
            let newItem = Workout(context: viewContext)
            newItem.timestamp = .now
            newItem.name = alertInput
            newItem.id = UUID().uuidString
            save()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { workouts[$0] }.forEach(viewContext.delete)
            save()
        }
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

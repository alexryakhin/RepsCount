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

    var body: some View {
        NavigationView {
            List {
                ForEach(workouts) { workout in
                    NavigationLink {
                        WorkoutView(workoutId: workout.id ?? "")
                            .navigationTitle(workout.name ?? "default name")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Text(workout.name ?? "default name")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Pull-ups counter")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Workout(context: viewContext)
            newItem.timestamp = .now
            newItem.name = Date.now.formatted(date: .abbreviated, time: .shortened)
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

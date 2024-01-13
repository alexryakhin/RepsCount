//
//  WorkoutView.swift
//  PullUpsCounter
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI

struct WorkoutView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest private var workouts: FetchedResults<Workout>
    private var workoutSets: [WorkoutSet] {
        let set = workouts[safe: 0]?.workoutSets as? Set<WorkoutSet> ?? []
        return set.sorted {
            $0.timestamp ?? .now < $1.timestamp ?? .now
        }
    }
    private var totalAmount: Int {
        Int(workoutSets.map { $0.amount }.reduce(0, +))
    }
    @State private var isShowingAlert = false
    @State private var alertInput = ""

    init(workoutId: String) {
        _workouts = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "id = %@", workoutId),
            animation: .default
        )
    }

    var body: some View {
        List {
            Section {
                ForEach(workoutSets) { workoutSet in
                    HStack {
                        Text("Set: \(workoutSet.amount)")
                        Spacer()
                        Text((workoutSet.timestamp ?? .now).formatted(date: .omitted, time: .shortened))
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete(perform: deleteItems)
            }

            Section("Total") {
                Text("Total: \(totalAmount)")
                    .bold()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button {
                    isShowingAlert = true
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .alert("Enter pull-ups amount", isPresented: $isShowingAlert) {
            TextField("Amount", text: $alertInput)
            Button("Add") {
                addItem()
            }
        }
    }

    private func addItem() {
        defer { alertInput = "" }
        guard let amount = Int64(alertInput) else { return }
        withAnimation {
            let newItem = WorkoutSet(context: viewContext)
            newItem.timestamp = .now
            newItem.id = UUID().uuidString
            newItem.amount = amount
            newItem.workout = workouts[safe: 0]
            save()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { workoutSets[$0] }.forEach(viewContext.delete)
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

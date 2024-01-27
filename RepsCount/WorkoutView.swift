//
//  WorkoutView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI
import MapKit

struct WorkoutView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest private var workouts: FetchedResults<Workout>
    private var workoutSets: [WorkoutSet] {
        let set = workouts.first?.workoutSets as? Set<WorkoutSet> ?? []
        return set.sorted {
            $0.timestamp ?? .now < $1.timestamp ?? .now
        }
    }
    private var totalAmount: Int {
        Int(workoutSets.map { $0.amount }.reduce(0, +))
    }
    private var isEditable: Bool {
        Calendar.current.isDateInToday(workouts.first?.timestamp ?? .now)
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
                        Text("\(workoutSet.amount) reps")
                        Spacer()
                        Text((workoutSet.timestamp ?? .now).formatted(date: .omitted, time: .shortened))
                            .foregroundStyle(.secondary)
                    }
                }
                .if(isEditable, transform: { view in
                    view.onDelete(perform: deleteItems)
                })
            }

            Section("Total") {
                Text("Reps: \(totalAmount)")
                Text("Sets: \(workoutSets.count)")
                if workoutSets.count > 1,
                   let firstSetDate = workoutSets.first?.timestamp,
                   let lastSetDate = workoutSets.last?.timestamp {
                    let distance = firstSetDate.distance(to: lastSetDate)
                    Text("Time: \(timeFormatter.string(from: distance)!)")
                }
            }

            if let latitude = workouts.first?.latitude, let longitude = workouts.first?.longitude {
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                Section("Map") {
                    Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: location, span: span)))) {
                        Marker(workouts.first?.name ?? "", coordinate: location)
                    }
                    .frame(height: 200)
                    .allowsHitTesting(false)
                    if let address = workouts.first?.address {
                        Text(address) .bold()
                    }
                }
            }

        }
        .toolbar {
            if isEditable {
                ToolbarItem {
                    Button {
                        isShowingAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(workouts.first?.name ?? "")
                        .font(.headline)
                    if let date = workouts.first?.timestamp {
                        Text(date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .alert("Enter the amount of reps", isPresented: $isShowingAlert) {
            TextField("Amount", text: $alertInput)
                .keyboardType(.numberPad)
            Button("Add") {
                addItem()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addItem() {
        defer { alertInput = "" }
        guard let amount = Int64(alertInput) else { return }
        withAnimation {
            let newItem = WorkoutSet(context: viewContext)
            newItem.timestamp = .now
            newItem.id = UUID().uuidString
            newItem.amount = amount
            newItem.workout = workouts.first
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

private let timeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.hour, .minute, .second]
    return formatter
}()

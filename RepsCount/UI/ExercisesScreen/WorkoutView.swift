//
//  WorkoutView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI
import MapKit

struct WorkoutView: View {
    @AppStorage("measurementUnit") var measurementUnit: MeasurementUnit = .kilograms

    @Environment(\.managedObjectContext) private var viewContext
    @FocusState private var isNotesInputFocused: Bool
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
    @State private var amountInput = ""
    @State private var weightInput = ""
    @State private var notesInput: String = ""

    init(workoutId: String) {
        _workouts = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "id = %@", workoutId),
            animation: .default
        )
    }

    var body: some View {
        List {
            setsSection
            totalSection
            mapSection
            notesSection
        }
        .toolbar {
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
            TextField("Amount", text: $amountInput)
                .keyboardType(.numberPad)
            TextField("Weight, \(Text(measurementUnit.shortName)) (optional)", text: $weightInput)
                .keyboardType(.decimalPad)
            Button("Add") {
                addItem()
            }
            Button("Cancel", role: .cancel) {
                amountInput = ""
                weightInput = ""
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottomTrailing) {
            if isEditable {
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
    }

    @ViewBuilder
    private var setsSection: some View {
        if !workoutSets.isEmpty {
            Section("Sets") {
                ForEach(Array(workoutSets.enumerated()), id: \.offset) { offset, workoutSet in
                    HStack {
                        if workoutSet.weight > 0 {
                            let converted: String = measurementUnit.convertFromKilograms(workoutSet.weight)
                            Text("#\(offset + 1): \(workoutSet.amount) reps, \(converted)")
                                .fontWeight(.semibold)
                        } else {
                            Text("#\(offset + 1): \(workoutSet.amount) reps")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        Text((workoutSet.timestamp ?? .now).formatted(date: .omitted, time: .shortened))
                            .foregroundStyle(.secondary)
                    }
                }
                .if(isEditable, transform: { view in
                    view.onDelete(perform: deleteItems)
                })
            }
        }
    }

    private var totalSection: some View {
        Section("Total") {
            Text("Reps: \(totalAmount)")
                .fontWeight(.semibold)
            Text("Sets: \(workoutSets.count)")
                .fontWeight(.semibold)
            if workoutSets.count > 1,
               let firstSetDate = workoutSets.first?.timestamp,
               let lastSetDate = workoutSets.last?.timestamp {
                let distance = firstSetDate.distance(to: lastSetDate)
                Text("Time: \(timeFormatter.string(from: distance)!)")
                    .fontWeight(.semibold)
            }
        }
    }

    @ViewBuilder
    private var mapSection: some View {
        if let latitude = workouts.first?.latitude,
           let longitude = workouts.first?.longitude,
           latitude != 0,
           longitude != 0 {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
            Section("Map") {
                Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: location, span: span)))) {
                    Marker(workouts.first?.name ?? "", coordinate: location)
                }
                .frame(height: 200)
                .allowsHitTesting(false)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                if let address = workouts.first?.address {
                    Text(address)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    @ViewBuilder
    private var notesSection: some View {
        Section("Notes") {
            if let notes = workouts.first?.notes {
                TextEditor(text: $notesInput)
                    .fontWeight(.medium)
                    .focused($isNotesInputFocused)
                    .padding(.bottom, -16)
                    .overlay(alignment: .leading) {
                        if notesInput.isEmpty {
                            Text("Start typing")
                                .foregroundStyle(.secondary)
                                .allowsHitTesting(false)
                                .padding(.horizontal, 4)
                        }
                    }
                if isNotesInputFocused {
                    Button("Save") {
                        workouts.first?.notes = notesInput
                        isNotesInputFocused = false
                        save()
                    }
                }
            } else {
                Button("Add notes") {
                    workouts.first?.notes = ""
                }
            }
        }
        .onAppear {
            notesInput = workouts.first?.notes ?? ""
        }
    }

    private func addItem() {
        defer { amountInput = "" }
        defer { weightInput = "" }
        guard let amount = Int64(amountInput) else { return }
        withAnimation {
            let newItem = WorkoutSet(context: viewContext)
            newItem.timestamp = .now
            newItem.id = UUID().uuidString
            newItem.amount = amount
            newItem.workout = workouts.first
            if let weight = Double(weightInput) {
                let kilograms = measurementUnit.convertToKilograms(weight)
                newItem.weight = kilograms.value
            }
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

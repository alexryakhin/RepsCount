//
//  ExerciseDetailsView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI
import MapKit

struct ExerciseDetailsView: View {
    @AppStorage("measurementUnit") var measurementUnit: MeasurementUnit = .kilograms
    @Environment(\.managedObjectContext) private var viewContext
    @FocusState private var isNotesInputFocused: Bool
    @State private var isShowingAlert = false
    @State private var amountInput = ""
    @State private var weightInput = ""
    @State private var notesInput = ""

    private let exercise: Exercise

    private var exerciseSets: [ExerciseSet] {
        let set = exercise.exerciseSets as? Set<ExerciseSet> ?? []
        return set.sorted {
            $0.timestamp ?? .now < $1.timestamp ?? .now
        }
    }
    private var totalAmount: Int {
        Int(exerciseSets.map { $0.amount }.reduce(0, +))
    }
    private var isEditable: Bool {
        Calendar.current.isDateInToday(exercise.timestamp ?? .now)
    }

    init(exercise: Exercise) {
        self.exercise = exercise
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
                    Text(LocalizedStringKey(exercise.name ?? ""))
                        .font(.headline)
                    if let date = exercise.timestamp {
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
                isShowingAlert = false
            }
            Button("Cancel", role: .cancel) {
                amountInput = ""
                weightInput = ""
                isShowingAlert = false
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
        if !exerciseSets.isEmpty {
            Section("Sets") {
                ForEach(Array(exerciseSets.enumerated()), id: \.offset) { offset, exerciseSet in
                    HStack {
                        if exerciseSet.weight > 0 {
                            let converted: String = measurementUnit.convertFromKilograms(exerciseSet.weight)
                            Text("#\(offset + 1): \(exerciseSet.amount) reps, \(converted)")
                                .fontWeight(.semibold)
                        } else {
                            Text("#\(offset + 1): \(exerciseSet.amount) reps")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        Text((exerciseSet.timestamp ?? .now).formatted(date: .omitted, time: .shortened))
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
            Text("Sets: \(exerciseSets.count)")
                .fontWeight(.semibold)
            if exerciseSets.count > 1,
               let firstSetDate = exerciseSets.first?.timestamp,
               let lastSetDate = exerciseSets.last?.timestamp {
                let distance = firstSetDate.distance(to: lastSetDate)
                Text("Time: \(timeFormatter.string(from: distance)!)")
                    .fontWeight(.semibold)
            }
        }
    }

    @ViewBuilder
    private var mapSection: some View {
        let latitude = exercise.latitude
        let longitude = exercise.longitude
        if latitude != 0,
           longitude != 0 {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
            Section("Map") {
                Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(center: location, span: span)))) {
                    Marker(exercise.name ?? "", coordinate: location)
                }
                .frame(height: 200)
                .allowsHitTesting(false)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                if let address = exercise.address {
                    Text(address)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    @ViewBuilder
    private var notesSection: some View {
        Section("Notes") {
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
                    exercise.notes = notesInput
                    isNotesInputFocused = false
                    save()
                }
            }
        }
        .onAppear {
            notesInput = exercise.notes ?? ""
        }
    }

    private func addItem() {
        defer { amountInput = "" }
        defer { weightInput = "" }
        guard let amount = Int64(amountInput) else { return }
        withAnimation {
            let newItem = ExerciseSet(context: viewContext)
            newItem.timestamp = .now
            newItem.id = UUID().uuidString
            newItem.amount = amount
            newItem.exercise = exercise
            if let weight = Double(weightInput) {
                let kilograms = measurementUnit.convertToKilograms(weight)
                newItem.weight = kilograms.value
            }
            save()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { exerciseSets[$0] }.forEach(viewContext.delete)
            save()
        }
    }

    private func save() {
        do {
            try viewContext.save()
        } catch {
            print("Error with saving on details screen, \(error.localizedDescription)")
        }
    }
}

private let timeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.hour, .minute, .second]
    return formatter
}()

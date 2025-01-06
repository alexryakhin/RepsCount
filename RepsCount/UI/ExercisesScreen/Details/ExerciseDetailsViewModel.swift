//
//  ExerciseDetailsView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/6/25.
//

import SwiftUI

class ExerciseDetailsViewModel: ObservableObject {
    @AppStorage("measurementUnit") var measurementUnit: MeasurementUnit = .kilograms

    @Published var isShowingAlert = false
    @Published var amountInput = ""
    @Published var weightInput = ""
    @Published var notesInput = ""

    let coreDataService = CoreDataService.shared
    let exercise: Exercise

    var exerciseSets: [ExerciseSet] {
        let set = exercise.exerciseSets as? Set<ExerciseSet> ?? []
        return set.sorted {
            $0.timestamp ?? .now < $1.timestamp ?? .now
        }
    }
    var totalAmount: Int {
        Int(exerciseSets.map { $0.amount }.reduce(0, +))
    }
    var isEditable: Bool {
        Calendar.current.isDateInToday(exercise.timestamp ?? .now)
    }

    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    func addItem() {
        defer { amountInput = "" }
        defer { weightInput = "" }
        guard let amount = Int64(amountInput) else { return }
        let newItem = ExerciseSet(context: coreDataService.context)
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

    func deleteItems(offsets: IndexSet) {
        offsets.map { exerciseSets[$0] }.forEach(coreDataService.context.delete)
        save()
    }

    func save() {
        try? coreDataService.saveContext()
    }
}

private let timeFormatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.allowedUnits = [.hour, .minute, .second]
    return formatter
}()

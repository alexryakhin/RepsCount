//
//  ExerciseDetailsView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/6/25.
//

import SwiftUI

final class ExerciseDetailsViewModel: ObservableObject {
    @AppStorage(UserDefaultsKey.measurementUnit.rawValue) var measurementUnit: MeasurementUnit = .kilograms

    @Published var isShowingAlert = false
    @Published var amountInput = ""
    @Published var weightInput = ""
    @Published var notesInput = ""

    private let coreDataService: CoreDataServiceInterface
    let exercise: Exercise

    var metricType: ExerciseMetricType {
        ExerciseMetricType(rawValue: exercise.metricType ?? "")
    }

    var exerciseSets: [ExerciseSet] {
        let set = exercise.exerciseSets as? Set<ExerciseSet> ?? []
        return set.sorted {
            $0.timestamp ?? .now < $1.timestamp ?? .now
        }
    }
    var totalAmount: Double {
        exerciseSets.map { $0.amount }.reduce(0, +)
    }
    var isEditable: Bool {
        Calendar.current.isDateInToday(exercise.timestamp ?? .now)
    }

    init(
        exercise: Exercise,
        coreDataService: CoreDataServiceInterface
    ) {
        self.exercise = exercise
        self.coreDataService = coreDataService
    }
    
    func addItem() {
        defer { amountInput = "" }
        defer { weightInput = "" }
        guard let amount = Double(amountInput) else { return }
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

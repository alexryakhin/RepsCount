//
//  Exercise+CoreDataClass.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreLocation

struct Exercise: Identifiable, Hashable {
    let model: ExerciseModel
    let id: String
    let timestamp: Date
    let sets: [ExerciseSet]
    var notes: String
    let location: Location?
    let workoutInstanceId: String?
    let defaultAmount: Double
    let defaultSets: Double

    var maxReps: Double? {
        if let maxReps = sets.map(\.amount).max() {
            return max(defaultAmount, maxReps)
        }
        return defaultAmount.nilIfZero ?? sets.map(\.amount).max()
    }

    var isCompleted: Bool {
        Calendar.current.isDateInToday(timestamp)
    }

    var totalDuration: TimeInterval? {
        guard sets.count > 1,
              let firstSetDate = sets.first?.timestamp,
              let lastSetDate = sets.last?.timestamp
        else { return nil }
        return firstSetDate.distance(to: lastSetDate)
    }

    init(
        model: ExerciseModel,
        id: String,
        timestamp: Date,
        sets: [ExerciseSet],
        notes: String,
        location: Location?,
        workoutInstanceId: String?,
        defaultAmount: Double,
        defaultSets: Double
    ) {
        self.model = model
        self.id = id
        self.timestamp = timestamp
        self.sets = sets
        self.notes = notes
        self.location = location
        self.workoutInstanceId = workoutInstanceId
        self.defaultAmount = defaultAmount
        self.defaultSets = defaultSets
    }
}

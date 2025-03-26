//
//  Exercise+CoreDataClass.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreLocation

public struct Exercise: Identifiable, Hashable {
    public let model: ExerciseModel
    public let id: String
    public let timestamp: Date
    public let sets: [ExerciseSet]
    public var notes: String
    public let location: Location?
    public let workoutInstanceId: String?
    public let defaultAmount: Double
    public let defaultSets: Double

    public var maxReps: Double? {
        if let maxReps = sets.map(\.amount).max() {
            return max(defaultAmount, maxReps)
        }
        return defaultAmount.nilIfZero ?? sets.map(\.amount).max()
    }

    public var isCompleted: Bool {
        Calendar.current.isDateInToday(timestamp)
    }

    public var totalDuration: TimeInterval? {
        guard sets.count > 1,
              let firstSetDate = sets.first?.timestamp,
              let lastSetDate = sets.last?.timestamp
        else { return nil }
        return firstSetDate.distance(to: lastSetDate)
    }

    public init(
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

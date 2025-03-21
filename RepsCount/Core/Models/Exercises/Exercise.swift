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
    public let location: Location?
    public let notes: String?
    public let workoutInstanceId: String?
    public let defaultReps: Double
    public let defaultSets: Double

    public var maxReps: Double? {
        if let maxReps = sets.map(\.amount).max() {
            return max(defaultReps, maxReps)
        }
        return defaultReps.nilIfZero ?? sets.map(\.amount).max()
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
        location: Location?,
        notes: String?,
        workoutInstanceId: String?,
        defaultReps: Double,
        defaultSets: Double
    ) {
        self.model = model
        self.id = id
        self.timestamp = timestamp
        self.sets = sets
        self.location = location
        self.notes = notes
        self.workoutInstanceId = workoutInstanceId
        self.defaultReps = defaultReps
        self.defaultSets = defaultSets
    }
}

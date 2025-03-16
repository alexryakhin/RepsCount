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
    public let model: any ExerciseModel
    public let id: String
    public let timestamp: Date
    public let sets: [ExerciseSet]
    public let location: Location?
    public let notes: String?

    public var isCompleted: Bool {
        Calendar.current.isDateInToday(timestamp)
    }

    public init(
        model: any ExerciseModel,
        id: String,
        timestamp: Date,
        sets: [ExerciseSet],
        location: Location?,
        notes: String?
    ) {
        self.model = model
        self.id = id
        self.timestamp = timestamp
        self.sets = sets
        self.location = location
        self.notes = notes
    }

    public static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(timestamp)
    }
}

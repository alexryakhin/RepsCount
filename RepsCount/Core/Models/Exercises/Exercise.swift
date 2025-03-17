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
    public let sortingOrder: Int

    public var isCompleted: Bool {
        Calendar.current.isDateInToday(timestamp)
    }

    public init(
        model: ExerciseModel,
        id: String,
        timestamp: Date,
        sets: [ExerciseSet],
        location: Location?,
        notes: String?,
        workoutInstanceId: String?,
        sortingOrder: Int
    ) {
        self.model = model
        self.id = id
        self.timestamp = timestamp
        self.sets = sets
        self.location = location
        self.notes = notes
        self.workoutInstanceId = workoutInstanceId
        self.sortingOrder = sortingOrder
    }
}

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
    public let name: String
    public let category: ExerciseCategory
    public let metricType: ExerciseMetricType
    public let id: String
    public let timestamp: Date
    public let sets: [ExerciseSet]
    public let calendarEventID: String?
    public let location: Location?
    public let notes: String?

    public init(
        name: String,
        category: ExerciseCategory,
        metricType: ExerciseMetricType,
        id: String,
        timestamp: Date,
        sets: [ExerciseSet],
        calendarEventID: String?,
        location: Location?,
        notes: String?
    ) {
        self.name = name
        self.category = category
        self.metricType = metricType
        self.id = id
        self.timestamp = timestamp
        self.sets = sets
        self.calendarEventID = calendarEventID
        self.location = location
        self.notes = notes
    }
}

//
//  Exercise+CoreDataClass.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreLocation

public struct Exercise: Identifiable {
    public let name: String
    public let category: ExerciseCategory
    public let type: ExerciseType
    public let metricType: ExerciseMetricType
    public let id: String
    public let timestamp: Date
    public let exerciseSets: Set<ExerciseSet>
    public let address: String?
    public let calendarEventID: String?
    public let location: CLLocationCoordinate2D?
    public let notes: String?

    public init(
        name: String,
        category: ExerciseCategory,
        type: ExerciseType,
        metricType: ExerciseMetricType,
        id: String,
        timestamp: Date,
        exerciseSets: Set<ExerciseSet>,
        address: String?,
        calendarEventID: String?,
        location: CLLocationCoordinate2D?,
        notes: String?
    ) {
        self.name = name
        self.category = category
        self.type = type
        self.metricType = metricType
        self.id = id
        self.timestamp = timestamp
        self.exerciseSets = exerciseSets
        self.address = address
        self.calendarEventID = calendarEventID
        self.location = location
        self.notes = notes
    }
}

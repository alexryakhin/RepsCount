//
//  CalendarEvent.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

public struct CalendarEvent: Identifiable, Hashable {
    public let date: Date
    public let id: String
    public let workoutTemplate: WorkoutTemplate
    public let recurrenceRule: String?
    public let eventIdentifier: String?

    public init(
        date: Date,
        id: String,
        workoutTemplate: WorkoutTemplate,
        recurrenceRule: String?,
        eventIdentifier: String?
    ) {
        self.date = date
        self.id = id
        self.workoutTemplate = workoutTemplate
        self.recurrenceRule = recurrenceRule
        self.eventIdentifier = eventIdentifier
    }
}

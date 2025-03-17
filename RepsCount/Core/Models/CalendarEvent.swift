//
//  CalendarEvent+CoreDataClass.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

public struct CalendarEvent: Identifiable {
    public let title: String
    public let date: Date
    public let id: String
    public let workoutTemplate: WorkoutTemplate
    public let notes: String?
    public let recurrenceRule: String?
    public let eventIdentifier: String?

    public init(
        title: String,
        date: Date,
        id: String,
        workoutTemplate: WorkoutTemplate,
        notes: String?,
        recurrenceRule: String?,
        eventIdentifier: String?
    ) {
        self.title = title
        self.date = date
        self.id = id
        self.workoutTemplate = workoutTemplate
        self.notes = notes
        self.recurrenceRule = recurrenceRule
        self.eventIdentifier = eventIdentifier
    }
}

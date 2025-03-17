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
    public let exercises: [ExerciseModel]
    public let notes: String?
    public let recurrenceRule: String?
    public let eventIdentifier: String?

    public init(
        title: String,
        date: Date,
        id: String = UUID().uuidString,
        exercises: [ExerciseModel] = [],
        notes: String? = nil,
        recurrenceRule: String? = nil,
        eventIdentifier: String? = nil
    ) {
        self.title = title
        self.date = date
        self.id = id
        self.exercises = exercises
        self.notes = notes
        self.recurrenceRule = recurrenceRule
        self.eventIdentifier = eventIdentifier
    }
}

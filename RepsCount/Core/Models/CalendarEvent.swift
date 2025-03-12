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
    public let exercises: Set<ExerciseModel>
    public let notes: String?
    public let recurrenceRule: Data?

    public init(
        title: String,
        date: Date,
        id: String = UUID().uuidString,
        exercises: Set<ExerciseModel> = [],
        notes: String? = nil,
        recurrenceRule: Data? = nil
    ) {
        self.title = title
        self.date = date
        self.id = id
        self.exercises = exercises
        self.notes = notes
        self.recurrenceRule = recurrenceRule
    }
}

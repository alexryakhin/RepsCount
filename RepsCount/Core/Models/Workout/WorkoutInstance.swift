//
//  WorkoutInstance.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

import Foundation

struct WorkoutInstance: Identifiable, Hashable {
    let id: String
    let date: Date
    let exercises: [Exercise]
    let workoutTemplate: WorkoutTemplate?
    let workoutEvent: WorkoutEvent?
    let completionTimeStamp: Date?
    let name: String?

    var defaultName: String {
        if let name = name?.nilIfEmpty {
            return name
        } else if let name = workoutTemplate?.name {
            return name
        }

        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12:
            return NSLocalizedString("Morning workout", comment: .empty)
        case 12..<18:
            return NSLocalizedString("Afternoon workout", comment: .empty)
        default:
            return NSLocalizedString("Evening workout", comment: .empty)
        }
    }

    var isCompleted: Bool {
        completionTimeStamp != nil
    }

    var totalDuration: TimeInterval? {
        guard let completionTimeStamp else { return nil }
        return date.distance(to: completionTimeStamp)
    }

    init(
        id: String,
        date: Date,
        exercises: [Exercise],
        completionTimeStamp: Date?,
        workoutTemplate: WorkoutTemplate? = nil,
        workoutEvent: WorkoutEvent? = nil,
        name: String? = nil
    ) {
        self.id = id
        self.date = date
        self.exercises = exercises
        self.completionTimeStamp = completionTimeStamp
        self.workoutTemplate = workoutTemplate
        self.workoutEvent = workoutEvent
        self.name = name
    }
}

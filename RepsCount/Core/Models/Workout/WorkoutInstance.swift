//
//  WorkoutInstance.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public struct WorkoutInstance: Identifiable, Hashable {
    public let id: String
    public let date: Date
    public let exercises: [Exercise]
    public let workoutTemplate: WorkoutTemplate?
    public let workoutEvent: WorkoutEvent?
    public let completionTimeStamp: Date?
    public let name: String?

    public var defaultName: String {
        if let name = name?.nilIfEmpty {
            return name
        } else if let name = workoutTemplate?.name {
            return name
        }

        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12:
            return "Morning workout"
        case 12..<18:
            return "Afternoon workout"
        default:
            return "Evening workout"
        }
    }

    public var isCompleted: Bool {
        completionTimeStamp != nil
    }

    public var totalDuration: TimeInterval? {
        guard let completionTimeStamp else { return nil }
        return date.distance(to: completionTimeStamp)
    }

    public init(
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

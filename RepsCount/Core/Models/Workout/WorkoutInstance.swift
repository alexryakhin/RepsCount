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
    public let workoutTemplate: WorkoutTemplate

    public var isCompleted: Bool {
        Calendar.current.isDateInToday(date)
    }

    public init(
        id: String,
        date: Date,
        exercises: [Exercise],
        workoutTemplate: WorkoutTemplate
    ) {
        self.id = id
        self.date = date
        self.exercises = exercises
        self.workoutTemplate = workoutTemplate
    }
}

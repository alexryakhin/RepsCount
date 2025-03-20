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
    public var completionTimeStamp: Date?

    public var title: String {
        workoutTemplate?.workoutTitle ?? "Open Workout"
    }

    public var isCompleted: Bool {
        completionTimeStamp != nil
    }

    public var totalDuration: TimeInterval? {
        let sortedExercises = exercises.sorted(by: { $0.timestamp < $1.timestamp })
        guard let firstExercise = sortedExercises.first,
              firstExercise.sets.count > 1,
              let firstSetDate = firstExercise.sets.first?.timestamp,
              let lastSetDate = sortedExercises.last?.sets.last?.timestamp
        else { return nil }
        return firstSetDate.distance(to: lastSetDate)
    }

    public init(
        id: String,
        date: Date,
        exercises: [Exercise],
        completionTimeStamp: Date?,
        workoutTemplate: WorkoutTemplate? = nil,
        workoutEvent: WorkoutEvent? = nil
    ) {
        self.id = id
        self.date = date
        self.exercises = exercises
        self.completionTimeStamp = completionTimeStamp
        self.workoutTemplate = workoutTemplate
        self.workoutEvent = workoutEvent
    }
}

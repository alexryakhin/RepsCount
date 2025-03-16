//
//  WorkoutTemplate.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public struct WorkoutTemplate: Identifiable {
    public let id: String
    public let name: String
    public let exercises: Set<WorkoutTemplateExercise>

    public init(
        id: String,
        name: String,
        exercises: Set<WorkoutTemplateExercise>
    ) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }
}

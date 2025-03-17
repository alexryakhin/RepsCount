//
//  WorkoutTemplate.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public struct WorkoutTemplate: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let templateExercises: [WorkoutTemplateExercise]
    public let workoutInstances: [WorkoutInstance]

    public init(
        id: String,
        name: String,
        templateExercises: [WorkoutTemplateExercise],
        workoutInstances: [WorkoutInstance]
    ) {
        self.id = id
        self.name = name
        self.templateExercises = templateExercises
        self.workoutInstances = workoutInstances
    }
}

//
//  WorkoutTemplateExercise.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public struct WorkoutTemplateExercise: Identifiable, Hashable {
    public let id: String
    public let exerciseModel: ExerciseModel
    public let defaultSets: Int
    public let defaultReps: Int
    public let workoutTemplates: [WorkoutTemplate]

    public init(
        id: String,
        exerciseModel: ExerciseModel,
        defaultSets: Int,
        defaultReps: Int,
        workoutTemplates: [WorkoutTemplate]
    ) {
        self.id = id
        self.exerciseModel = exerciseModel
        self.defaultSets = defaultSets
        self.defaultReps = defaultReps
        self.workoutTemplates = workoutTemplates
    }
}

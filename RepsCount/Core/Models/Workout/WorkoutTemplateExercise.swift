//
//  WorkoutTemplateExercise.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public struct WorkoutTemplateExercise: Identifiable, Hashable {
    public let id: String
    public let exerciseModel: ExerciseModel
    public var defaultSets: Int
    public var defaultReps: Int
    public let timestamp: Date

    public init(
        id: String,
        exerciseModel: ExerciseModel,
        defaultSets: Int,
        defaultReps: Int,
        timestamp: Date
    ) {
        self.id = id
        self.exerciseModel = exerciseModel
        self.defaultSets = defaultSets
        self.defaultReps = defaultReps
        self.timestamp = timestamp
    }
}

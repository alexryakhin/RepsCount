//
//  WorkoutTemplateExercise.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public struct WorkoutTemplateExercise: Identifiable, Hashable {
    public let id: String
    public let exerciseModel: ExerciseModel
    public var defaultSets: Double
    public var defaultAmount: Double
    public let timestamp: Date

    public init(
        id: String,
        exerciseModel: ExerciseModel,
        defaultSets: Double,
        defaultAmount: Double,
        timestamp: Date
    ) {
        self.id = id
        self.exerciseModel = exerciseModel
        self.defaultSets = defaultSets
        self.defaultAmount = defaultAmount
        self.timestamp = timestamp
    }
}

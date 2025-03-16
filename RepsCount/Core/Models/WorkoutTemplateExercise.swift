//
//  WorkoutTemplateExercise.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public struct WorkoutTemplateExercise: Identifiable, Hashable {
    public static func == (lhs: WorkoutTemplateExercise, rhs: WorkoutTemplateExercise) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: String
    public let exerciseModel: any ExerciseModel
    public let defaultSets: Int

    public init(
        id: String,
        exerciseModel: any ExerciseModel,
        defaultSets: Int
    ) {
        self.id = id
        self.exerciseModel = exerciseModel
        self.defaultSets = defaultSets
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//
//  WorkoutTemplateExercise.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

import Foundation

struct WorkoutTemplateExercise: Identifiable, Hashable {
    let id: String
    let exerciseModel: ExerciseModel
    var defaultSets: Double
    var defaultAmount: Double
    let timestamp: Date

    init(
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

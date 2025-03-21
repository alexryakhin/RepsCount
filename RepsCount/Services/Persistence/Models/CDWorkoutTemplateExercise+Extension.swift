//
//  CDWorkoutTemplateExercise+Extension.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/17/25.
//
//

import Foundation
import CoreData
import Core

extension CDWorkoutTemplateExercise {

    var coreModel: WorkoutTemplateExercise? {
        guard let id,
              let exerciseModel,
              let timestamp,
              let model = ExerciseModel(rawValue: exerciseModel) else {
            return nil
        }
        return WorkoutTemplateExercise(
            id: id,
            exerciseModel: model,
            defaultSets: defaultSets.int,
            defaultReps: defaultReps.int,
            timestamp: timestamp
        )
    }
}

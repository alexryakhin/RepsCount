//
//  CDWorkoutInstance+Extension.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/17/25.
//
//

import Foundation
import CoreData
import Core

extension CDWorkoutInstance {

    var _exercises: [CDExercise] {
        let sets = exercises as? Set<CDExercise> ?? []
        return sets.sorted {
            $0.sortingOrder < $1.sortingOrder
        }
    }

    var coreModel: WorkoutInstance? {
        guard let id, let date else { return nil }
        return WorkoutInstance(
            id: id,
            date: date,
            exercises: _exercises.compactMap(\.coreModel),
            completionTimeStamp: completionTimeStamp,
            workoutTemplate: workoutTemplate?.coreModel,
            workoutEvent: workoutEvent?.coreModel
        )
    }
}

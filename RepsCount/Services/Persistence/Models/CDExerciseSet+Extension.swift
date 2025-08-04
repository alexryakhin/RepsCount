//
//  CDExerciseSet+Extension.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreData

extension CDExerciseSet {

    var coreModel: ExerciseSet? {
        guard let id, let timestamp, let exerciseID = exercise?.id else { return nil }
        return ExerciseSet(
            amount: amount,
            weight: weight,
            id: id,
            timestamp: timestamp,
            exerciseID: exerciseID
        )
    }
}

//
//  CDExercise+Extension.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreData
import Core

extension CDExercise {

    var _exerciseSets: [CDExerciseSet] {
        let sets = exerciseSets as? Set<CDExerciseSet> ?? []
        return sets.sorted {
            $0.timestamp ?? .now < $1.timestamp ?? .now
        }
    }

    var coreModel: Exercise? {
        guard let name,
              let model: ExerciseModel = .init(rawValue: name),
              let id,
              let timestamp
        else { return nil }
        var location: Location? {
            guard latitude != 0, longitude != 0 else { return nil }
            return Location(latitude: latitude, longitude: longitude, address: address)
        }
        return Exercise(
            model: model,
            id: id,
            timestamp: timestamp,
            sets: _exerciseSets.compactMap(\.coreModel),
            location: location,
            notes: notes,
            workoutInstanceId: workoutInstance?.id,
            sortingOrder: sortingOrder.int
        )
    }
}

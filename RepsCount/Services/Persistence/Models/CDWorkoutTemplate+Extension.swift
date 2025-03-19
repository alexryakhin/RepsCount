//
//  CDWorkoutTemplate+Extension.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/17/25.
//
//

import Foundation
import CoreData
import Core

extension CDWorkoutTemplate {

    var _templateExercises: [CDWorkoutTemplateExercise] {
        let sets = templateExercises as? Set<CDWorkoutTemplateExercise> ?? []
        return sets.sorted {
            $0.sortingOrder < $1.sortingOrder
        }
    }

    var _workoutInstances: [CDWorkoutInstance] {
        let sets = workoutInstances as? Set<CDWorkoutInstance> ?? []
        return sets.sorted {
            $0.date ?? .now < $1.date ?? .now
        }
    }

    var _workoutEvents: [CDWorkoutEvent] {
        let sets = workoutEvents as? Set<CDWorkoutEvent> ?? []
        return sets.sorted {
            $0.date ?? .now < $1.date ?? .now
        }
    }

    var coreModel: WorkoutTemplate? {
        guard let id, let name else { return nil }

        return WorkoutTemplate(
            id: id,
            name: name,
            notes: notes,
            templateExercises: _templateExercises.compactMap(\.coreModel),
            workoutInstances: _workoutInstances.compactMap(\.coreModel),
            workoutEventIds: _workoutEvents.compactMap(\.id)
        )
    }
}

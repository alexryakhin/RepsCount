//
//  CDWorkoutEvent+Extension.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/17/25.
//
//

import Foundation
import CoreData
import Core

extension CDWorkoutEvent {

    var coreModel: WorkoutEvent? {
        guard let date,
              let workoutTemplate = workoutTemplate?.coreModel,
              let id
        else { return nil }

        return WorkoutEvent(
            template: workoutTemplate,
            days: [],
            startAt: startAt.int,
            repeats: nil,
            interval: nil,
            occurrenceCount: nil,
            duration: WorkoutEventDuration(rawValue: duration.int) ?? .oneHour,
            date: date,
            id: id,
            recurrenceId: recurrenceId,
            workoutInstanceId: workoutInstance?.id
        )
    }
}

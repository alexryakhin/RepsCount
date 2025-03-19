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
              let daysStr = days,
              let id
        else { return nil }

        let days: [WorkoutEventDay] = daysStr.components(separatedBy: ";").compactMap({ Int($0) }).compactMap({ WorkoutEventDay(rawValue: $0) })

        return WorkoutEvent(
            template: workoutTemplate,
            days: days,
            startAt: startAt.int,
            repeats: WorkoutEventRecurrence(rawValue: repeats.int),
            interval: interval.int,
            occurrenceCount: occurrenceCount.int,
            duration: WorkoutEventDuration(rawValue: duration.int) ?? .oneHour,
            date: date,
            id: id,
            recurrenceId: recurrenceId
        )
    }
}

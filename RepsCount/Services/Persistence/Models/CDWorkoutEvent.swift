//
//  CDWorkoutEvent.swift
//  UserInterface
//
//  Created by Aleksandr Riakhin on 3/17/25.
//
//

import Foundation
import CoreData
import Core

@objc(CDWorkoutEvent)
final class CDWorkoutEvent: NSManagedObject, Identifiable {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDWorkoutEvent> {
        return NSFetchRequest<CDWorkoutEvent>(entityName: "WorkoutEvent")
    }

    @NSManaged var workoutTemplate: CDWorkoutTemplate? // WorkoutTemplate
    @NSManaged var type: Int64 // WorkoutEventType (enum)
    @NSManaged var days: String? // separated values like "0;1;2;3"
    @NSManaged var startAt: Int64
    @NSManaged var repeats: Int64 // WorkoutEventRecurrence (enum)
    @NSManaged var interval: Int64 // recurrence interval
    @NSManaged var occurrenceCount: Int64 // how often the workout event occurs
    @NSManaged var duration: Int64 // duration of the workout (enum)
    @NSManaged var dateCreated: Date?

    var id: String? {
        workoutTemplate?.name
    }

    var coreModel: WorkoutEvent? {
        guard let dateCreated,
              let workoutTemplate = workoutTemplate?.coreModel,
              let type = WorkoutEventType(rawValue: type.int),
              let daysStr = days
        else { return nil }

        let days: [WorkoutEventDay] = daysStr.components(separatedBy: ";").compactMap({ Int($0) }).compactMap({ WorkoutEventDay(rawValue: $0) })

        return WorkoutEvent(
            template: workoutTemplate,
            type: type,
            days: days,
            startAt: startAt.int,
            repeats: WorkoutEventRecurrence(rawValue: repeats.int),
            interval: interval.int,
            occurrenceCount: occurrenceCount.int,
            duration: WorkoutEventDuration(rawValue: duration.int) ?? .oneHour,
            dateCreated: dateCreated
        )
    }
}

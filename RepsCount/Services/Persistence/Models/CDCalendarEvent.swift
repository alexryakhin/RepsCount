//
//  CDCalendarEvent.swift
//  UserInterface
//
//  Created by Aleksandr Riakhin on 3/17/25.
//
//

import Foundation
import CoreData
import Core

@objc(CDCalendarEvent)
final class CDCalendarEvent: NSManagedObject, Identifiable {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDCalendarEvent> {
        return NSFetchRequest<CDCalendarEvent>(entityName: "CalendarEvent")
    }

    @NSManaged var date: Date?
    @NSManaged var id: String?
    @NSManaged var workoutTemplate: CDWorkoutTemplate?
    @NSManaged var recurrenceRule: String?
    @NSManaged var eventIdentifier: String?

    var coreModel: CalendarEvent? {
        guard let date,
              let id,
              let workoutTemplate = workoutTemplate?.coreModel
        else { return nil }

        return CalendarEvent(
            date: date,
            id: id,
            workoutTemplate: workoutTemplate,
            recurrenceRule: recurrenceRule,
            eventIdentifier: eventIdentifier
        )
    }
}

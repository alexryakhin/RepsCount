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

    @NSManaged var title: String?
    @NSManaged var date: Date?
    @NSManaged var id: String?
    @NSManaged var workoutTemplate: CDWorkoutTemplate?
    @NSManaged var notes: String?
    @NSManaged var recurrenceRule: String?
    @NSManaged var eventIdentifier: String?

    var coreModel: CalendarEvent? {
        guard let title,
              let date,
              let id,
              let workoutTemplate = workoutTemplate?.coreModel
        else { return nil }

        return CalendarEvent(
            title: title,
            date: date,
            id: id,
            workoutTemplate: workoutTemplate,
            notes: notes,
            recurrenceRule: recurrenceRule,
            eventIdentifier: eventIdentifier
        )
    }
}

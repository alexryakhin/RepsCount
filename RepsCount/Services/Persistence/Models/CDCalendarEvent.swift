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
    @NSManaged var exercises: String?
    @NSManaged var notes: String?
    @NSManaged var recurrenceRule: String?
    @NSManaged var eventIdentifier: String?

    var coreModel: CalendarEvent? {
        guard let title,
              let date,
              let id,
              let exercises
        else { return nil }

        let exerciseModels = exercises.components(separatedBy: ";").compactMap {
            ExerciseModel(rawValue: $0)
        }
        return CalendarEvent(
            title: title,
            date: date,
            id: id,
            exercises: exerciseModels,
            notes: notes,
            recurrenceRule: recurrenceRule,
            eventIdentifier: eventIdentifier
        )
    }
}

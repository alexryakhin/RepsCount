//
//  CDCalendarEvent.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreData
import Core

@objc(CDCalendarEvent)
final class CDCalendarEvent: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCalendarEvent> {
        return NSFetchRequest<CDCalendarEvent>(entityName: "CalendarEvent")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var notes: String?
    @NSManaged public var recurrenceRule: Data?
    @NSManaged public var title: String?
    @NSManaged public var exercises: NSSet?

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: CDExerciseModel)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: CDExerciseModel)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

    var exerciseModels: Set<ExerciseModel> {
        let sets = exercises as? Set<CDExerciseModel> ?? []
        return Set(sets.compactMap(\.coreModel))
    }

    var coreModel: CalendarEvent? {
        guard let date,
              let id,
              let title
        else { return nil }
        return CalendarEvent(
            title: title,
            date: date,
            id: id,
            exercises: exerciseModels,
            notes: notes,
            recurrenceRule: recurrenceRule
        )
    }
}

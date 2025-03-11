//
//  CalendarEvent+CoreDataProperties.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreData


extension CalendarEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalendarEvent> {
        return NSFetchRequest<CalendarEvent>(entityName: "CalendarEvent")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var notes: String?
    @NSManaged public var recurrenceRule: Data?
    @NSManaged public var title: String?
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension CalendarEvent {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseModel)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseModel)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension CalendarEvent : Identifiable {

}

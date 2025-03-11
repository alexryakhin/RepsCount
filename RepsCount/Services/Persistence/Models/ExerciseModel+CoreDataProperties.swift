//
//  ExerciseModel+CoreDataProperties.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreData


extension ExerciseModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseModel> {
        return NSFetchRequest<ExerciseModel>(entityName: "ExerciseModel")
    }

    @NSManaged public var category: String?
    @NSManaged public var defaultReps: Int16
    @NSManaged public var defaultSets: Int16
    @NSManaged public var defaultWeight: Double
    @NSManaged public var id: String?
    @NSManaged public var metricType: String?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var type: String?
    @NSManaged public var calendarEvents: NSSet?

}

// MARK: Generated accessors for calendarEvents
extension ExerciseModel {

    @objc(addCalendarEventsObject:)
    @NSManaged public func addToCalendarEvents(_ value: CalendarEvent)

    @objc(removeCalendarEventsObject:)
    @NSManaged public func removeFromCalendarEvents(_ value: CalendarEvent)

    @objc(addCalendarEvents:)
    @NSManaged public func addToCalendarEvents(_ values: NSSet)

    @objc(removeCalendarEvents:)
    @NSManaged public func removeFromCalendarEvents(_ values: NSSet)

}

extension ExerciseModel : Identifiable {

}

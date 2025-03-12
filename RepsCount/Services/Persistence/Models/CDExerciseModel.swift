//
//  CDExerciseModel.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreData
import Core

@objc(CDExerciseModel)
final class CDExerciseModel: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDExerciseModel> {
        return NSFetchRequest<CDExerciseModel>(entityName: "ExerciseModel")
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

    @objc(addCalendarEventsObject:)
    @NSManaged public func addToCalendarEvents(_ value: CDCalendarEvent)

    @objc(removeCalendarEventsObject:)
    @NSManaged public func removeFromCalendarEvents(_ value: CDCalendarEvent)

    @objc(addCalendarEvents:)
    @NSManaged public func addToCalendarEvents(_ values: NSSet)

    @objc(removeCalendarEvents:)
    @NSManaged public func removeFromCalendarEvents(_ values: NSSet)

    var coreModel: ExerciseModel? {
        guard let name,
              let category = ExerciseCategory(rawValue: category ?? ""),
              let type = ExerciseType(rawValue: type ?? ""),
              let id
        else { return nil }
        return ExerciseModel(
            name: name,
            category: category,
            type: type,
            metricType: .init(rawValue: metricType ?? ""),
            id: id,
            defaultReps: Int(defaultReps),
            defaultSets: Int(defaultSets),
            defaultWeight: defaultWeight,
            notes: notes
        )
    }
}

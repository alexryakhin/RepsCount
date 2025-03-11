//
//  Exercise+CoreDataProperties.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var address: String?
    @NSManaged public var category: String?
    @NSManaged public var eventID: String?
    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var metricType: String?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var type: String?
    @NSManaged public var exerciseSets: NSSet?

}

// MARK: Generated accessors for exerciseSets
extension Exercise {

    @objc(addExerciseSetsObject:)
    @NSManaged public func addToExerciseSets(_ value: ExerciseSet)

    @objc(removeExerciseSetsObject:)
    @NSManaged public func removeFromExerciseSets(_ value: ExerciseSet)

    @objc(addExerciseSets:)
    @NSManaged public func addToExerciseSets(_ values: NSSet)

    @objc(removeExerciseSets:)
    @NSManaged public func removeFromExerciseSets(_ values: NSSet)

}

extension Exercise : Identifiable {

}

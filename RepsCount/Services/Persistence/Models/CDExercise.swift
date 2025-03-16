//
//  CDExercise.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreData
import Core

@objc(CDExercise)
final class CDExercise: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDExercise> {
        return NSFetchRequest<CDExercise>(entityName: "Exercise")
    }

    @NSManaged public var address: String?
    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var exerciseSets: NSSet?

    @objc(addExerciseSetsObject:)
    @NSManaged public func addToExerciseSets(_ value: CDExerciseSet)

    @objc(removeExerciseSetsObject:)
    @NSManaged public func removeFromExerciseSets(_ value: CDExerciseSet)

    @objc(addExerciseSets:)
    @NSManaged public func addToExerciseSets(_ values: NSSet)

    @objc(removeExerciseSets:)
    @NSManaged public func removeFromExerciseSets(_ values: NSSet)

    var sets: [CDExerciseSet] {
        let sets = exerciseSets as? Set<CDExerciseSet> ?? []
        return sets.sorted {
            $0.timestamp ?? .now < $1.timestamp ?? .now
        }
    }

    var coreModel: Exercise? {
        guard let name,
              let model: any ExerciseModel = exerciseModel(from: name),
              let id,
              let timestamp
        else { return nil }
        var location: Location? {
            guard latitude != 0, longitude != 0 else { return nil }
            return Location(latitude: latitude, longitude: longitude, address: address)
        }
        return Exercise(
            model: model,
            id: id,
            timestamp: timestamp,
            sets: sets.compactMap(\.coreModel),
            location: location,
            notes: notes
        )
    }
}

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

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDExercise> {
        return NSFetchRequest<CDExercise>(entityName: "Exercise")
    }

    @NSManaged var address: String?
    @NSManaged var id: String?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var timestamp: Date?
    @NSManaged var exerciseSets: NSSet?
    @NSManaged var workoutInstance: CDWorkoutInstance?
    @NSManaged var sortingOrder: Int64

    @objc(addExerciseSetsObject:)
    @NSManaged func addToExerciseSets(_ value: CDExerciseSet)

    @objc(removeExerciseSetsObject:)
    @NSManaged func removeFromExerciseSets(_ value: CDExerciseSet)

    @objc(addExerciseSets:)
    @NSManaged func addToExerciseSets(_ values: NSSet)

    @objc(removeExerciseSets:)
    @NSManaged func removeFromExerciseSets(_ values: NSSet)

    var _exerciseSets: [CDExerciseSet] {
        let sets = exerciseSets as? Set<CDExerciseSet> ?? []
        return sets.sorted {
            $0.timestamp ?? .now < $1.timestamp ?? .now
        }
    }

    var coreModel: Exercise? {
        guard let name,
              let model: ExerciseModel = .init(rawValue: name),
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
            sets: _exerciseSets.compactMap(\.coreModel),
            location: location,
            notes: notes,
            workoutInstanceId: workoutInstance?.id,
            sortingOrder: Int(sortingOrder)
        )
    }
}

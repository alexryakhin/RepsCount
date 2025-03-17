//
//  CDWorkoutInstance.swift
//  UserInterface
//
//  Created by Aleksandr Riakhin on 3/17/25.
//
//

import Foundation
import CoreData
import Core

@objc(CDWorkoutInstance)
final class CDWorkoutInstance: NSManagedObject, Identifiable {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDWorkoutInstance> {
        return NSFetchRequest<CDWorkoutInstance>(entityName: "WorkoutInstance")
    }

    @NSManaged var id: String?
    @NSManaged var date: Date?
    @NSManaged var workoutTemplate: CDWorkoutTemplate?
    @NSManaged var exercises: NSSet?

    @objc(insertObject:inExercisesAtIndex:)
    @NSManaged func insertIntoExercises(_ value: CDExercise, at idx: Int)

    @objc(removeObjectFromExercisesAtIndex:)
    @NSManaged func removeFromExercises(at idx: Int)

    @objc(insertExercises:atIndexes:)
    @NSManaged func insertIntoExercises(_ values: [CDExercise], at indexes: NSIndexSet)

    @objc(removeExercisesAtIndexes:)
    @NSManaged func removeFromExercises(at indexes: NSIndexSet)

    @objc(replaceObjectInExercisesAtIndex:withObject:)
    @NSManaged func replaceExercises(at idx: Int, with value: CDExercise)

    @objc(replaceExercisesAtIndexes:withExercises:)
    @NSManaged func replaceExercises(at indexes: NSIndexSet, with values: [CDExercise])

    @objc(addExercisesObject:)
    @NSManaged func addToExercises(_ value: CDExercise)

    @objc(removeExercisesObject:)
    @NSManaged func removeFromExercises(_ value: CDExercise)

    @objc(addExercises:)
    @NSManaged func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged func removeFromExercises(_ values: NSSet)

    var _exercises: [CDExercise] {
        let sets = exercises as? Set<CDExercise> ?? []
        return sets.sorted {
            $0.sortingOrder < $1.sortingOrder
        }
    }

    var coreModel: WorkoutInstance? {
        guard let id, let date, let workoutTemplate = workoutTemplate?.coreModel else { return nil }
        return WorkoutInstance(
            id: id,
            date: date,
            exercises: _exercises.compactMap(\.coreModel),
            workoutTemplate: workoutTemplate
        )
    }
}

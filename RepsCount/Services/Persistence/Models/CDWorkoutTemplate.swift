//
//  CDWorkoutTemplate.swift
//  UserInterface
//
//  Created by Aleksandr Riakhin on 3/17/25.
//
//

import Foundation
import CoreData
import Core

@objc(CDWorkoutTemplate)
final class CDWorkoutTemplate: NSManagedObject, Identifiable {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDWorkoutTemplate> {
        return NSFetchRequest<CDWorkoutTemplate>(entityName: "WorkoutTemplate")
    }

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var templateExercises: NSSet?
    @NSManaged var workoutInstances: NSSet?
    @NSManaged var workoutEvent: CDWorkoutEvent?

    @objc(insertObject:inTemplateExercisesAtIndex:)
    @NSManaged func insertIntoTemplateExercises(_ value: CDWorkoutTemplateExercise, at idx: Int)

    @objc(removeObjectFromTemplateExercisesAtIndex:)
    @NSManaged func removeFromTemplateExercises(at idx: Int)

    @objc(insertTemplateExercises:atIndexes:)
    @NSManaged func insertIntoTemplateExercises(_ values: [CDWorkoutTemplateExercise], at indexes: NSIndexSet)

    @objc(removeTemplateExercisesAtIndexes:)
    @NSManaged func removeFromTemplateExercises(at indexes: NSIndexSet)

    @objc(replaceObjectInTemplateExercisesAtIndex:withObject:)
    @NSManaged func replaceTemplateExercises(at idx: Int, with value: CDWorkoutTemplateExercise)

    @objc(replaceTemplateExercisesAtIndexes:withTemplateExercises:)
    @NSManaged func replaceTemplateExercises(at indexes: NSIndexSet, with values: [CDWorkoutTemplateExercise])

    @objc(addTemplateExercisesObject:)
    @NSManaged func addToTemplateExercises(_ value: CDWorkoutTemplateExercise)

    @objc(removeTemplateExercisesObject:)
    @NSManaged func removeFromTemplateExercises(_ value: CDWorkoutTemplateExercise)

    @objc(addTemplateExercises:)
    @NSManaged func addToTemplateExercises(_ values: NSSet)

    @objc(removeTemplateExercises:)
    @NSManaged func removeFromTemplateExercises(_ values: NSSet)

    @objc(addWorkoutInstancesObject:)
    @NSManaged func addToWorkoutInstances(_ value: CDWorkoutInstance)

    @objc(removeWorkoutInstancesObject:)
    @NSManaged func removeFromWorkoutInstances(_ value: CDWorkoutInstance)

    @objc(addWorkoutInstances:)
    @NSManaged func addToWorkoutInstances(_ values: NSSet)

    @objc(removeWorkoutInstances:)
    @NSManaged func removeFromWorkoutInstances(_ values: NSSet)

    var _templateExercises: [CDWorkoutTemplateExercise] {
        let sets = templateExercises as? Set<CDWorkoutTemplateExercise> ?? []
        return sets.sorted {
            $0.sortingOrder < $1.sortingOrder
        }
    }

    var _workoutInstances: [CDWorkoutInstance] {
        let sets = workoutInstances as? Set<CDWorkoutInstance> ?? []
        return sets.sorted {
            $0.date ?? .now < $1.date ?? .now
        }
    }

    var coreModel: WorkoutTemplate? {
        guard let id, let name else { return nil }

        return WorkoutTemplate(
            id: id,
            name: name,
            notes: notes,
            templateExercises: _templateExercises.compactMap(\.coreModel),
            workoutInstances: _workoutInstances.compactMap(\.coreModel),
            workoutEventId: workoutEvent?.id
        )
    }
}

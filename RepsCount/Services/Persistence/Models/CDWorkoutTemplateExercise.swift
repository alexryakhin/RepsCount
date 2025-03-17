//
//  CDWorkoutTemplateExercise.swift
//  UserInterface
//
//  Created by Aleksandr Riakhin on 3/17/25.
//
//

import Foundation
import CoreData
import Core

@objc(CDWorkoutTemplateExercise)
final class CDWorkoutTemplateExercise: NSManagedObject, Identifiable {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDWorkoutTemplateExercise> {
        return NSFetchRequest<CDWorkoutTemplateExercise>(entityName: "WorkoutTemplateExercise")
    }

    @NSManaged var id: String?
    @NSManaged var exerciseModel: String?
    @NSManaged var defaultSets: Int64
    @NSManaged var defaultReps: Int64
    @NSManaged var workoutTemplate: CDWorkoutTemplate?
    @NSManaged var sortingOrder: Int64

//    @objc(addWorkoutTemplatesObject:)
//    @NSManaged func addToWorkoutTemplates(_ value: CDWorkoutTemplate)
//
//    @objc(removeWorkoutTemplatesObject:)
//    @NSManaged func removeFromWorkoutTemplates(_ value: CDWorkoutTemplate)
//
//    @objc(addWorkoutTemplates:)
//    @NSManaged func addToWorkoutTemplates(_ values: NSSet)
//
//    @objc(removeWorkoutTemplates:)
//    @NSManaged func removeFromWorkoutTemplates(_ values: NSSet)

    var coreModel: WorkoutTemplateExercise? {
        guard let id,
              let exerciseModel,
              let model = ExerciseModel(rawValue: exerciseModel) else {
            return nil
        }
        return WorkoutTemplateExercise(
            id: id,
            exerciseModel: model,
            defaultSets: defaultSets.int,
            defaultReps: defaultReps.int,
            sortingOrder: sortingOrder.int
        )
    }
}

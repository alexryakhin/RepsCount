//
//  ExerciseSet+CoreDataClass.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreData
import Core

@objc(CDExerciseSet)
final class CDExerciseSet: NSManagedObject, Identifiable {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDExerciseSet> {
        return NSFetchRequest<CDExerciseSet>(entityName: "ExerciseSet")
    }

    @NSManaged var amount: Double
    @NSManaged var id: String?
    @NSManaged var timestamp: Date?
    @NSManaged var weight: Double
    @NSManaged var exercise: CDExercise?

    var coreModel: ExerciseSet? {
        guard let id, let timestamp, let exerciseID = exercise?.id else { return nil }
        return ExerciseSet(
            amount: amount,
            weight: weight,
            id: id,
            timestamp: timestamp,
            exerciseID: exerciseID
        )
    }
}

//
//  ExerciseSet+CoreDataClass.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreData

@objc(CDExerciseSet)
final class CDExerciseSet: NSManagedObject, Identifiable {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDExerciseSet> {
        return NSFetchRequest<CDExerciseSet>(entityName: "ExerciseSet")
    }

    @NSManaged var amount: Double
    @NSManaged var id: String?
    @NSManaged var timestamp: Date?
    @NSManaged var unit: String?
    @NSManaged var weight: Double
    @NSManaged var exercise: CDExercise?
}

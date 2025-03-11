//
//  ExerciseSet+CoreDataProperties.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import CoreData


extension ExerciseSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSet> {
        return NSFetchRequest<ExerciseSet>(entityName: "ExerciseSet")
    }

    @NSManaged public var amount: Double
    @NSManaged public var id: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var unit: String?
    @NSManaged public var weight: Double
    @NSManaged public var exercise: Exercise?

}

extension ExerciseSet : Identifiable {

}

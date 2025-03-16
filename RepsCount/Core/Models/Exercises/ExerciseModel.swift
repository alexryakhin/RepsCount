//
//  ExerciseModel+CoreDataClass.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

public protocol ExerciseModel: RawRepresentable, Identifiable, Hashable where RawValue == String {
    var rawValue: String { get }
    var type: ExerciseType { get }
    var equipment: ExerciseEquipment { get }
    var metricType: ExerciseMetricType { get }
    var primaryMuscleGroups: [MuscleGroup] { get }
    var secondaryMuscleGroups: [MuscleGroup] { get }
    var category: ExerciseCategory { get }
}

public func exerciseModel(from rawValue: String) -> (any ExerciseModel)? {
    let allExerciseTypes: [any ExerciseModel.Type] = [
        BicepsExerciseModel.self,
        TricepsExerciseModel.self,
        DeltoidsExerciseModel.self,
        PectoralsExerciseModel.self,
        QuadricepsExerciseModel.self,
        HamstringsExerciseModel.self,
        GlutesExerciseModel.self,
        CalvesExerciseModel.self,
        LatsExerciseModel.self,
        TrapeziusExerciseModel.self,
        LowerBackExerciseModel.self,
        AbdominalsExerciseModel.self,
        ForearmsExerciseModel.self
    ]

    for type in allExerciseTypes {
        if let exercise = type.init(rawValue: rawValue) {
            return exercise
        }
    }

    return nil // If no match found
}

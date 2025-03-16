//
//  LowerBackExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//


public enum LowerBackExerciseModel: String, CaseIterable, ExerciseModel {

    case hyperextensions = "Hyperextensions"
    case goodMornings = "Good Mornings"
    case superman = "Superman"
    case backExtensions = "Back Extensions"

    public var id: String { rawValue }

    public var category: ExerciseCategory {
        return .lowerBack
    }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .hyperextensions, .goodMornings, .backExtensions:
            return .gym
        case .superman:
            return .none
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .hyperextensions, .goodMornings, .superman, .backExtensions:
            return [.thoracolumbarFascia]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .hyperextensions, .goodMornings, .backExtensions:
            return [.gluteusMaximus]
        case .superman:
            return [.trapezius]
        }
    }
}

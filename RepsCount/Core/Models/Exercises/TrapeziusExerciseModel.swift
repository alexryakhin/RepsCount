//
//  TrapeziusExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//


public enum TrapeziusExerciseModel: String, CaseIterable, ExerciseModel {

    case shrugs = "Shrugs"
    case uprightRows = "Upright Rows"
    case facePulls = "Face Pulls"
    case rackPulls = "Rack Pulls"
    case farmerWalk = "Farmer's Walk"

    public var id: String { rawValue }

    public var category: ExerciseCategory {
        return .trapezius
    }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .shrugs, .uprightRows, .facePulls, .rackPulls:
            return .gym
        case .farmerWalk:
            return .none
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .shrugs, .uprightRows, .facePulls, .rackPulls, .farmerWalk:
            return [.trapezius]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .uprightRows, .facePulls:
            return [.deltoids]
        case .rackPulls:
            return [.thoracolumbarFascia]
        case .farmerWalk:
            return [.brachioradialis]
        default:
            return []
        }
    }
}

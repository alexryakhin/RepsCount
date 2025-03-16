//
//  LatsExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public enum LatsExerciseModel: String, CaseIterable, ExerciseModel {

    case pullUps = "Pull-ups"
    case latPulldowns = "Lat Pulldowns"
    case barbellRows = "Barbell Rows"
    case dumbbellRows = "Dumbbell Rows"
    case seatedCableRows = "Seated Cable Rows"
    case tBarRows = "T-bar Rows"
    case oneArmPullUp = "One Arm Pull-up"
    case resistanceBandPulldowns = "Resistance Band Pulldowns"
    case resistanceBandRows = "Resistance Band Rows"
    case invertedRows = "Inverted Rows"
    case machineRows = "Machine Rows"

    public var id: String { rawValue }

    public var category: ExerciseCategory {
        return .lats
    }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .pullUps, .oneArmPullUp, .invertedRows:
            return .bars
        case .latPulldowns, .barbellRows, .dumbbellRows, .seatedCableRows, .tBarRows, .machineRows:
            return .gym
        case .resistanceBandPulldowns, .resistanceBandRows:
            return .resistanceBands
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .pullUps, .latPulldowns, .oneArmPullUp, .resistanceBandPulldowns:
            return [.latissimusDorsi]
        case .barbellRows, .dumbbellRows, .seatedCableRows, .tBarRows, .resistanceBandRows, .machineRows:
            return [.latissimusDorsi, .rhomboidMajor]
        case .invertedRows:
            return [.latissimusDorsi, .trapezius]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .pullUps, .latPulldowns, .oneArmPullUp, .resistanceBandPulldowns:
            return [.biceps]
        case .barbellRows, .dumbbellRows, .seatedCableRows, .tBarRows, .resistanceBandRows, .machineRows:
            return [.deltoids]
        case .invertedRows:
            return [.biceps, .deltoids]
        }
    }
}

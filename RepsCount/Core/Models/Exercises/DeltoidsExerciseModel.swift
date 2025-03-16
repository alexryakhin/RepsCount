//
//  DeltoidsExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public enum DeltoidsExerciseModel: String, CaseIterable, ExerciseModel {

    case overheadPress = "Overhead Press"
    case arnoldPress = "Arnold Press"
    case lateralRaises = "Lateral Raises"
    case frontRaises = "Front Raises"
    case rearDeltFlyes = "Rear Delt Flyes"
    case handstandPushUps = "Handstand Push-ups"
    case resistanceBandLateralRaises = "Resistance Band Lateral Raises"
    case resistanceBandFrontRaises = "Resistance Band Front Raises"
    case resistanceBandOverheadPress = "Resistance Band Overhead Press"

    public var id: String { rawValue }

    public var category: ExerciseCategory {
        return .deltoids
    }

    public var type: ExerciseType {
        switch self {
        case .handstandPushUps:
            return .calisthenics
        default:
            return .strengthTraining
        }
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .overheadPress, .arnoldPress, .lateralRaises, .frontRaises, .rearDeltFlyes:
            return .gym
        case .handstandPushUps:
            return .none
        case .resistanceBandLateralRaises, .resistanceBandFrontRaises, .resistanceBandOverheadPress:
            return .resistanceBands
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .overheadPress, .arnoldPress, .handstandPushUps, .resistanceBandOverheadPress:
            return [.deltoids]
        case .lateralRaises, .resistanceBandLateralRaises:
            return [.deltoids]
        case .frontRaises, .resistanceBandFrontRaises:
            return [.deltoids]
        case .rearDeltFlyes:
            return [.deltoids]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .overheadPress, .arnoldPress, .handstandPushUps, .resistanceBandOverheadPress:
            return [.triceps]
        case .lateralRaises, .resistanceBandLateralRaises:
            return [.trapezius]
        case .frontRaises, .resistanceBandFrontRaises:
            return [.serratusAnterior]
        case .rearDeltFlyes:
            return [.rhomboidMajor]
        }
    }
}

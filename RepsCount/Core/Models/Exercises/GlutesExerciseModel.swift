//
//  GlutesExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public enum GlutesExerciseModel: String, CaseIterable, ExerciseModel {
    case gluteBridge = "Glute Bridge"
    case hipThrust = "Hip Thrust"
    case squats = "Squats"
    case lunges = "Lunges"
    case deadlifts = "Deadlifts"
    case sumoDeadlifts = "Sumo Deadlifts"
    case bulgarianSplitSquat = "Bulgarian Split Squat"
    case stepUps = "Step Ups"

    public var id: String { rawValue }

    public var category: ExerciseCategory {
        return .glutes
    }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .gluteBridge, .hipThrust, .bulgarianSplitSquat, .stepUps:
            return .gym
        case .squats, .lunges, .deadlifts, .sumoDeadlifts:
            return .none
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .gluteBridge, .hipThrust, .squats, .lunges, .deadlifts, .sumoDeadlifts, .bulgarianSplitSquat, .stepUps:
            return [.gluteusMaximus]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .gluteBridge, .hipThrust, .bulgarianSplitSquat, .stepUps:
            return [.bicepsFemoris, .semitendinosus]
        case .squats, .lunges:
            return [.rectusFemoris, .vastusLateralis, .vastusMedialis]
        case .deadlifts, .sumoDeadlifts:
            return [.thoracolumbarFascia]
        }
    }
}

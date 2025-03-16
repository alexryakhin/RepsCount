//
//  QuadricepsExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public enum QuadricepsExerciseModel: String, CaseIterable, ExerciseModel {

    case squats = "Squats"
    case lunges = "Lunges"
    case legPress = "Leg Press"
    case splitSquat = "Split Squat"
    case bulgarianSplitSquat = "Bulgarian Split Squat"
    case pistolSquat = "Pistol Squat"
    case stepUps = "Step Ups"
    case hackSquat = "Hack Squat"
    case sissySquat = "Sissy Squat"
    case legExtensions = "Leg Extensions"

    public var id: String { rawValue }

    public var category: ExerciseCategory {
        return .quadriceps
    }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .squats, .lunges, .splitSquat, .bulgarianSplitSquat, .pistolSquat, .sissySquat:
            return .none
        case .legPress, .hackSquat, .legExtensions:
            return .gym
        case .stepUps:
            return .resistanceBands
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .squats, .lunges, .legPress, .splitSquat, .bulgarianSplitSquat, .pistolSquat, .stepUps, .hackSquat, .sissySquat, .legExtensions:
            return [.rectusFemoris, .vastusLateralis, .vastusMedialis]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .squats, .lunges, .splitSquat, .bulgarianSplitSquat, .pistolSquat, .stepUps:
            return [.gluteusMaximus, .adductorMagnus]
        case .hackSquat, .legExtensions:
            return [.gluteusMaximus]
        case .sissySquat:
            return [.rectusAbdominis]
        default:
            return []
        }
    }
}

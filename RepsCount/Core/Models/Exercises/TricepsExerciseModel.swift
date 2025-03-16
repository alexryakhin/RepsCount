//
//  TricepsExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//


public enum TricepsExerciseModel: String, CaseIterable, ExerciseModel {

    case tricepDips = "Tricep Dips"
    case tricepExtension = "Tricep Extension"
    case closeGripBenchPress = "Close-Grip Bench Press"
    case skullCrushers = "Skull Crushers"
    case overheadTricepsExtension = "Overhead Triceps Extension"
    case resistanceBandTricepsExtension = "Resistance Band Triceps Extension"

    public var id: String { rawValue }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var category: ExerciseCategory {
        return .triceps
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .tricepDips:
            return .none
        case .tricepExtension, .closeGripBenchPress, .skullCrushers, .overheadTricepsExtension:
            return .gym
        case .resistanceBandTricepsExtension:
            return .resistanceBands
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .tricepDips, .tricepExtension, .closeGripBenchPress, .skullCrushers, .overheadTricepsExtension, .resistanceBandTricepsExtension:
            return [.triceps]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .tricepDips:
            return [.pectoralisMajor, .deltoids]
        case .closeGripBenchPress:
            return [.pectoralisMajor]
        case .overheadTricepsExtension:
            return [.deltoids]
        default:
            return []
        }
    }
}

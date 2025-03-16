//
//  PectoralsExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public enum PectoralsExerciseModel: String, CaseIterable, ExerciseModel {

    case dips = "Dips"
    case pushUps = "Push-ups"
    case diamondPushUps = "Diamond Push-ups"
    case dumbbellFlyes = "Dumbbell Flyes"
    case benchPress = "Bench Press"
    case chestPress = "Chest Press"
    case cableCrossover = "Cable Crossover"
    case inclineBenchPress = "Incline Bench Press"
    case declineBenchPress = "Decline Bench Press"
    case resistanceBandChestPress = "Resistance Band Chest Press"
    case resistanceBandFlyes = "Resistance Band Flyes"
    case machineChestPress = "Machine Chest Press"

    public var id: String { rawValue }

    public var category: ExerciseCategory {
        return .pectorals
    }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .dips, .pushUps, .diamondPushUps:
            return .none
        case .dumbbellFlyes, .benchPress, .chestPress, .cableCrossover, .inclineBenchPress, .declineBenchPress, .machineChestPress:
            return .gym
        case .resistanceBandChestPress, .resistanceBandFlyes:
            return .resistanceBands
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .dips, .pushUps, .diamondPushUps, .dumbbellFlyes, .benchPress, .chestPress, .cableCrossover, .inclineBenchPress, .declineBenchPress, .machineChestPress, .resistanceBandChestPress, .resistanceBandFlyes:
            return [.pectoralisMajor]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .dips:
            return [.triceps, .deltoids]
        case .pushUps, .diamondPushUps:
            return [.triceps, .serratusAnterior]
        case .benchPress, .inclineBenchPress, .declineBenchPress:
            return [.triceps]
        case .dumbbellFlyes, .cableCrossover, .resistanceBandFlyes:
            return [.deltoids]
        case .machineChestPress, .resistanceBandChestPress:
            return [.triceps]
        default:
            return []
        }
    }
}

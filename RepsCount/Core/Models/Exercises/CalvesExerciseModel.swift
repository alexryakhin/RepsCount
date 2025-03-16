//
//  CalvesExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public enum CalvesExerciseModel: String, CaseIterable, ExerciseModel {

    case calfRaises = "Calf Raises"
    case toeRaises = "Toe Raises"
    case seatedCalfRaises = "Seated Calf Raises"
    case standingCalfRaises = "Standing Calf Raises"
    case donkeyCalfRaises = "Donkey Calf Raises"

    public var id: String { rawValue }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var category: ExerciseCategory {
        return .calves
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .calfRaises, .toeRaises, .seatedCalfRaises:
            return .gym
        case .standingCalfRaises, .donkeyCalfRaises:
            return .none
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .calfRaises, .seatedCalfRaises, .standingCalfRaises, .donkeyCalfRaises:
            return [.gastrocnemius]
        case .toeRaises:
            return [.peroneusLongus]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .calfRaises, .toeRaises, .seatedCalfRaises, .standingCalfRaises, .donkeyCalfRaises:
            return [.soleus]
        }
    }
}

//
//  HamstringsExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public enum HamstringsExerciseModel: String, CaseIterable, ExerciseModel {

    case deadlifts = "Deadlifts"
    case legCurls = "Leg Curls"
    case romanianDeadlifts = "Romanian Deadlifts"
    case nordicCurls = "Nordic Curls"
    case gluteHamRaises = "Glute-Ham Raises"
    case singleLegDeadlifts = "Single-Leg Deadlifts"

    public var id: String { rawValue }

    public var category: ExerciseCategory {
        return .hamstrings
    }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .deadlifts, .romanianDeadlifts, .singleLegDeadlifts:
            return .none
        case .legCurls, .gluteHamRaises:
            return .gym
        case .nordicCurls:
            return .resistanceBands
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .deadlifts, .romanianDeadlifts, .legCurls, .nordicCurls, .gluteHamRaises, .singleLegDeadlifts:
            return [.bicepsFemoris, .semitendinosus]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .deadlifts, .romanianDeadlifts, .singleLegDeadlifts:
            return [.gluteusMaximus]
        case .legCurls, .gluteHamRaises:
            return [.adductorMagnus]
        case .nordicCurls:
            return [.gracilis]
        }
    }
}

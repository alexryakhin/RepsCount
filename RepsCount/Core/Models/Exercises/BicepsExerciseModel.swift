//
//  BicepsExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public enum BicepsExerciseModel: String, CaseIterable, ExerciseModel {
    case bicepCurls = "Bicep Curls"
    case hammerCurls = "Hammer Curls"
    case chinUps = "Chin-ups"
    case concentrationCurls = "Concentration Curls"
    case preacherCurls = "Preacher Curls"
    case cableCurls = "Cable Curls"
    case reverseCurls = "Reverse Curls"

    public var id: String { rawValue }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var category: ExerciseCategory {
        return .biceps
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .bicepCurls, .hammerCurls, .concentrationCurls, .preacherCurls, .cableCurls, .reverseCurls:
            return .gym
        case .chinUps:
            return .bars
        }
    }

    public var metricType: ExerciseMetricType {
        return .weightAndReps
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .bicepCurls, .hammerCurls, .chinUps, .concentrationCurls, .preacherCurls, .cableCurls, .reverseCurls:
            return [.biceps]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .bicepCurls, .hammerCurls, .concentrationCurls, .preacherCurls, .cableCurls, .reverseCurls:
            return [.brachialis, .brachioradialis]
        case .chinUps:
            return [.latissimusDorsi, .brachialis]
        }
    }
}

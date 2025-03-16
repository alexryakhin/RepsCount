//
//  AbdominalsExerciseModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public enum AbdominalsExerciseModel: String, CaseIterable, ExerciseModel {

    case crunches = "Crunches"
    case russianTwist = "Russian Twist"
    case legRaises = "Leg Raises"
    case obliqueTwist = "Oblique Twist"
    case lSit = "L-sit"
    case legRaisesBar = "Leg Raises on Bar"
    case legRaisesParallettes = "Leg Raises on Parallettes"
    case plank = "Plank"
    case sidePlank = "Side Plank"

    public var id: String { rawValue }

    public var type: ExerciseType {
        return .strengthTraining
    }

    public var category: ExerciseCategory {
        return .abdominals
    }

    public var equipment: ExerciseEquipment {
        switch self {
        case .crunches, .russianTwist, .legRaises, .obliqueTwist, .lSit, .plank, .sidePlank:
            return .none
        case .legRaisesBar, .legRaisesParallettes:
            return .bars
        }
    }

    public var metricType: ExerciseMetricType {
        switch self {
        case .crunches, .legRaises, .legRaisesBar, .legRaisesParallettes, .russianTwist, .obliqueTwist:
            return .weightAndReps
        case .lSit, .plank, .sidePlank:
            return .time
        }
    }

    public var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .crunches, .legRaises, .legRaisesBar, .legRaisesParallettes, .lSit, .plank, .sidePlank:
            return [.rectusAbdominis, .rectusAbdominisLower]
        case .russianTwist, .obliqueTwist:
            return [.externalObliques]
        }
    }

    public var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .crunches, .legRaises, .legRaisesBar, .legRaisesParallettes, .lSit, .plank, .sidePlank:
            return [.externalObliques, .serratusAnterior]
        case .russianTwist, .obliqueTwist:
            return [.rectusAbdominis]
        }
    }
}

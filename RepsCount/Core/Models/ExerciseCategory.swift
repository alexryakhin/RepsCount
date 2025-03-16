//
//  ExerciseCategory.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/12/25.
//

public enum ExerciseCategory: String, CaseIterable {
    case calves = "Calves"
    case quadriceps = "Quadriceps"
    case hamstrings = "Hamstrings"
    case glutes = "Glutes"
    case lowerBack = "Lower Back"
    case lats = "Lats"
    case trapezius = "Trapezius"
    case abdominals = "Abdominals"
    case pectorals = "Pectorals"
    case deltoids = "Deltoids"
    case triceps = "Triceps"
    case biceps = "Biceps"
    case forearms = "Forearms"

    public var exercises: [any ExerciseModel] {
        switch self {
        case .calves:
            return CalvesExerciseModel.allCases
        case .quadriceps:
            return QuadricepsExerciseModel.allCases
        case .hamstrings:
            return HamstringsExerciseModel.allCases
        case .glutes:
            return GlutesExerciseModel.allCases
        case .lowerBack:
            return LowerBackExerciseModel.allCases
        case .lats:
            return LatsExerciseModel.allCases
        case .trapezius:
            return TricepsExerciseModel.allCases
        case .abdominals:
            return AbdominalsExerciseModel.allCases
        case .pectorals:
            return PectoralsExerciseModel.allCases
        case .deltoids:
            return DeltoidsExerciseModel.allCases
        case .triceps:
            return TricepsExerciseModel.allCases
        case .biceps:
            return BicepsExerciseModel.allCases
        case .forearms:
            return ForearmsExerciseModel.allCases
        }
    }
}

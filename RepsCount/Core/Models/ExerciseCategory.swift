//
//  ExerciseCategory.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/12/25.
//

public enum ExerciseCategory: String, CaseIterable {
    case legs = "Legs"
    case core = "Core"
    case arms = "Arms"
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"

    case strengthSkills = "Strength Skills"
    case mobility = "Mobility"
    case balance = "Balance"

    public var type: ExerciseType {
        switch self {
        case .legs, .core, .arms, .chest, .back, .shoulders:
                .strengthTraining
        case .strengthSkills, .mobility, .balance:
                .calisthenics
        }
    }
}

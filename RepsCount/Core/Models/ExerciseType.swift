//
//  ExerciseType.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/12/25.
//

public enum ExerciseType: String, CaseIterable {
    case strengthTraining = "Strength Training"
    case calisthenics = "Calisthenics"

    public var categories: [ExerciseCategory] {
        switch self {
        case .strengthTraining:
            [.legs, .core, .arms, .chest, .back, .shoulders]
        case .calisthenics:
            [.strengthSkills, .mobility, .balance]
        }
    }
}

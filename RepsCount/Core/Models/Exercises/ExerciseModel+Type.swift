//
//  ExerciseModel+Type.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

public extension ExerciseModel {
    var type: ExerciseType {
        switch self {
        case .planche, .frontLever, .backLever, .humanFlag, .muscleUps, .handstandPushUps:
            return .calisthenics
        default:
            return .strengthTraining
        }
    }
}

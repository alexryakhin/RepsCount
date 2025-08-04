//
//  ExerciseModel+Type.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

extension ExerciseModel {
    var type: ExerciseType {
        switch self {
        case .planche, .frontLever, .backLever, .humanFlag, .muscleUps, .handstandPushUps, .elbowLever, .scapulaPushUps, .scapulaPullUps, .plancheLean, .pikePushUps, .handstandToeTouch, .frogPose, .lSitLegLifts:
            return .calisthenics
        default:
            return .strengthTraining
        }
    }
}

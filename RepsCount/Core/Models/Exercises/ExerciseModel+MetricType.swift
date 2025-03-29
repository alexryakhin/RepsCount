//
//  ExerciseModel.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

public extension ExerciseModel {
    var metricType: ExerciseMetricType {
        switch self {
        case .lSit, .plank, .sidePlank, .dragonFlag: // Existing core holds
            return .time
        case .deadHang: // Forearm and grip endurance hold
            return .time
        case .pinchGripHold: // Forearm static hold
            return .time
        case .copenhagenPlank: // Adductor and core hold
            return .time
        case .planche, .frontLever, .backLever, .humanFlag: // Calisthenics isometric holds
            return .time
        case .mountainClimbers, .jumpingJacks, .bearCrawls, .inchworms, .battleRopes, .sledPush:
            return .time
        case .wallSit, .elbowLever, .plancheLean, .frogPose:
            return .time
        default:
            return .reps
        }
    }
}

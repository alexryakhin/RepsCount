//
//  ExerciseMetricType.swift
//  Core
//
//  Created by Aleksandr Riakhin on 1/7/25.
//

import Foundation

public enum ExerciseMetricType: Equatable {
    case weightAndReps      // Strength
    case time               // Static holds (e.g., L-sit, Plank)

    public var rawValue: String {
        switch self {
        case .weightAndReps: "weightAndReps"
        case .time: "time"
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "weightAndReps": self = .weightAndReps
        case "time": self = .time
        default: self = .weightAndReps
        }
    }
}

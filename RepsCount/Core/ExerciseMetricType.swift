//
//  ExerciseMetricType.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/7/25.
//
import Foundation

enum ExerciseMetricType: Equatable {
    case weightAndReps      // Strength
    case distanceAndTime    // Cardio
    case timeOnly           // Static holds (e.g., L-sit, Plank)
    case custom(String)     // Flexible for anything else (e.g., progression level, skill)

    var rawValue: String {
        switch self {
        case .weightAndReps: "weightAndReps"
        case .distanceAndTime: "distanceAndTime"
        case .timeOnly: "timeOnly"
        case .custom: "custom"
        }
    }

    init(rawValue: String) {
        switch rawValue {
        case "weightAndReps": self = .weightAndReps
        case "distanceAndTime": self = .distanceAndTime
        case "timeOnly": self = .timeOnly
        default: self = .custom(rawValue)
        }
    }
}

//
//  ExerciseMetricType.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/7/25.
//
import Foundation

public enum ExerciseMetricType: Equatable {
    case weightAndReps      // Strength
    case distanceAndTime    // Cardio
    case timeOnly           // Static holds (e.g., L-sit, Plank)

    public var rawValue: String {
        switch self {
        case .weightAndReps: "weightAndReps"
        case .distanceAndTime: "distanceAndTime"
        case .timeOnly: "timeOnly"
        }
    }

    public init(rawValue: String) {
        switch rawValue {
        case "weightAndReps": self = .weightAndReps
        case "distanceAndTime": self = .distanceAndTime
        case "timeOnly": self = .timeOnly
        default: self = .weightAndReps
        }
    }
}

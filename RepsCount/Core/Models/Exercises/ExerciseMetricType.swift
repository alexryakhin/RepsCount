//
//  ExerciseMetricType.swift
//  Core
//
//  Created by Aleksandr Riakhin on 1/7/25.
//

import Foundation

enum ExerciseMetricType: String, Equatable {
    case reps // Strength
    case time // Static holds (e.g., L-sit, Plank)

    var enterValueLocalizedString: String {
        switch self {
        case .reps: NSLocalizedString("Enter the amount of reps", comment: .empty)
        case .time: NSLocalizedString("Enter time", comment: .empty)
        }
    }

    var amountLocalizedString: String {
        switch self {
        case .reps: NSLocalizedString("Amount", comment: .empty)
        case .time: NSLocalizedString("Time (seconds)", comment: .empty)
        }
    }
}

//
//  ExerciseEquipment.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

import Foundation

enum ExerciseEquipment: String, CaseIterable, Identifiable, Codable {
    case none = "No Equipment"
    case gym = "Gym"
    case resistanceBands = "Resistance Bands"
    case bars = "Bars"

    var id: String { rawValue }

    var localizedName: String {
        NSLocalizedString(rawValue, comment: .empty)
    }

    static var allCasesData: Data {
        let allCases = ExerciseEquipment.allCases
        return try! JSONEncoder().encode(allCases)
    }
}

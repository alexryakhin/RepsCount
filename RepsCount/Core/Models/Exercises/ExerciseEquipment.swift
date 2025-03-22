//
//  ExerciseEquipment.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public enum ExerciseEquipment: String, CaseIterable, Identifiable, Codable {
    case none = "No Equipment"
    case gym = "Gym"
    case resistanceBands = "Resistance Bands"
    case bars = "Bars"

    public var id: String { rawValue }

    public var localizedName: String {
        NSLocalizedString(rawValue, comment: .empty)
    }

    public static var allCasesData: Data {
        let allCases = ExerciseEquipment.allCases
        return try! JSONEncoder().encode(allCases)
    }
}

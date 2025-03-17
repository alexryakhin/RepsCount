//
//  ExerciseEquipment.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public enum ExerciseEquipment: String, CaseIterable, Identifiable {
    case none = "No Equipment"
    case gym = "Gym"
    case resistanceBands = "Resistance Bands"
    case bars = "Bars"

    public var id: String { rawValue }
}

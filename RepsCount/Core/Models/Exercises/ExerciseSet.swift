//
//  ExerciseSet.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

public struct ExerciseSet: Identifiable, Hashable {
    public let amount: Double
    public let weight: Double
    public let id: String
    public let timestamp: Date
    public let exerciseID: String

    public init(
        amount: Double,
        weight: Double,
        id: String,
        timestamp: Date,
        exerciseID: String
    ) {
        self.amount = amount
        self.weight = weight
        self.id = id
        self.timestamp = timestamp
        self.exerciseID = exerciseID
    }
}

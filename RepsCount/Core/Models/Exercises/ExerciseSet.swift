//
//  ExerciseSet.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

struct ExerciseSet: Identifiable, Hashable {
    let amount: Double
    let weight: Double
    let id: String
    let timestamp: Date
    let exerciseID: String

    init(
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

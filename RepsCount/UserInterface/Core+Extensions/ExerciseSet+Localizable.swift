//
//  MuscleGroup+Localizable.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/21/25.
//

import SwiftUI

extension ExerciseSet {
    func setRepsText(index: Int, weight: String?) -> Text {
        if let weight {
            return Text("#\(index): \(Int(amount).repsCountShortLocalized), \(weight)")
        } else {
            return Text("#\(index): \(Int(amount).repsCountShortLocalized)")
        }
    }

    func setTimeText(index: Int, weight: String?) -> Text {
        if let weight {
            return Text("#\(index): \(amount.formatted(with: [.minute, .second])), \(weight)")
        } else {
            return Text("#\(index): \(amount.formatted(with: [.minute, .second]))")
        }
    }
}

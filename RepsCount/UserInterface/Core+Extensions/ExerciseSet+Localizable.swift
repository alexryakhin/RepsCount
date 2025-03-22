//
//  MuscleGroup+Localizable.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/21/25.
//

import Core
import SwiftUI

extension ExerciseSet {
    func setRepsText(index: Int, weight: String?) -> Text {
        let specifier = amount.defaultSpecifier
        if let weight {
            return Text("#\(index): \(amount, specifier: specifier) reps, \(weight)")
        } else {
            return Text("#\(index): \(amount, specifier: specifier) reps")
        }
    }

    func setTimeText(index: Int, weight: String?) -> Text {
        if let weight {
            return Text("#\(index): \(timeFormatter.string(from: amount)!), \(weight)")
        } else {
            return Text("#\(index): \(timeFormatter.string(from: amount)!)")
        }
    }
}

private var timeFormatter: DateComponentsFormatter = {
    let timeFormatter = DateComponentsFormatter()
    timeFormatter.unitsStyle = .short
    timeFormatter.allowedUnits = [.minute, .second]

    return timeFormatter
}()

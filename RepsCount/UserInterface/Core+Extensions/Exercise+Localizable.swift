//
//  Exercise+Localizable.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

import SwiftUI

extension ExerciseType {
    var name: String {
        NSLocalizedString(rawValue, comment: rawValue)
    }
}

extension ExerciseCategory {
    var name: String {
        NSLocalizedString(rawValue, comment: rawValue)
    }
}

extension ExerciseModel {
    var name: String {
        NSLocalizedString(rawValue, comment: rawValue)
    }

    var categoriesLocalizedNames: String {
        categories.removedDuplicates.map { NSLocalizedString($0.rawValue, comment: $0.rawValue) }.joined(separator: ", ")
    }
}

//
//  Exercise+Localizable.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

import Core
import CoreUserInterface
import SwiftUI

extension ExerciseType {
    public var name: String {
        NSLocalizedString(rawValue, comment: rawValue)
    }
}

extension ExerciseCategory {
    public var name: String {
        NSLocalizedString(rawValue, comment: rawValue)
    }
}

extension ExerciseModel {
    public var name: String {
        NSLocalizedString(rawValue, comment: rawValue)
    }

    public var categoriesLocalizedNames: String {
        categories.removedDuplicates.map { NSLocalizedString($0.rawValue, comment: $0.rawValue) }.joined(separator: ", ")
    }
}

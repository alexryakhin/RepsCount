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
    public var name: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
}

extension ExerciseCategory {
    public var name: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
}

extension ExerciseModel {
    public var name: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
}

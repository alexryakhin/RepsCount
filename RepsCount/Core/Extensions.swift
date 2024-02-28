//
//  Extensions.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import Foundation
import SwiftUI

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension String {
    var localized: String {
        let language = Locale.current.language.languageCode?.identifier
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else { return self }
        guard let bundle = Bundle(path: path) else { return self }
        let localizedString = NSLocalizedString(self, bundle: bundle, comment: "")

        return localizedString
    }
}

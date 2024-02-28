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
    static func localizedString(
        for key: String,
        locale: Locale = .current
    ) -> String {

        let language = locale.language.languageCode?.identifier
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")

        return localizedString
    }

    func localized(locale: Locale = .current) -> String {
        let language = locale.language.languageCode?.identifier
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(self, bundle: bundle, comment: "")

        return localizedString
    }
}

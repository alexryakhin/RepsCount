//
//  DefaultPlaceholderProps.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation
import SwiftUI

struct DefaultPlaceholderProps: Equatable {

    let title: LocalizedStringKey?
    let subtitle: LocalizedStringKey?

    init(
        title: LocalizedStringKey? = nil,
        subtitle: LocalizedStringKey? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
    }
}

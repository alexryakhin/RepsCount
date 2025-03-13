//
//  DefaultPlaceholderProps.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation
import SwiftUI

public struct DefaultPlaceholderProps: Equatable {

    let title: LocalizedStringKey?
    let subtitle: LocalizedStringKey?

    public init(
        title: LocalizedStringKey? = nil,
        subtitle: LocalizedStringKey? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
    }
}

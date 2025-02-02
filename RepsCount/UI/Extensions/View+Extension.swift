//
//  View+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/21/24.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func scrollTargetLayoutIfAvailable() -> some View {
        if #available(iOS 17, *) {
            self.scrollTargetLayout()
        } else {
            self
        }
    }

    @ViewBuilder
    func scrollClipDisabledIfAvailable() -> some View {
        if #available(iOS 17, *) {
            self.scrollClipDisabled()
        } else {
            self
        }
    }

    func clippedWithBackground(_ color: Color = .surface) -> some View {
        self
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension ScrollView {
    @ViewBuilder
    func scrollTargetBehaviorIfAvailable() -> some View {
        if #available(iOS 17, *) {
            self.scrollTargetBehavior(.viewAligned)
        } else {
            self
        }
    }
}

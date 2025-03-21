//
//  ScrollView+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//
import SwiftUI

public extension ScrollView {
    @ViewBuilder
    func scrollTargetBehaviorIfAvailable() -> some View {
        if #available(iOS 17, *) {
            self.scrollTargetBehavior(.viewAligned)
        } else {
            self
        }
    }
}

public extension List {
    @ViewBuilder
    func scrollContentBackgroundIfAvailable(_ visibility: Visibility) -> some View {
        if #available(iOS 16, *) {
            self.scrollContentBackground(visibility)
        } else {
            self
        }
    }
}

public extension View {
    @ViewBuilder
    func scrollTargetLayoutIfAvailable() -> some View {
        if #available(iOS 17, *) {
            self.scrollTargetLayout()
        } else {
            self
        }
    }

    @ViewBuilder
    func scrollClipDisabledIfAvailable(_ disabled: Bool = true) -> some View {
        if #available(iOS 17, *) {
            self.scrollClipDisabled(disabled)
        } else {
            self
        }
    }

    func clippedWithBackground(_ color: Color) -> some View {
        self
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func clippedWithBackground(_ material: Material) -> some View {
        self
            .background(material)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func clippedWithPaddingAndBackground(_ color: Color) -> some View {
        self
            .padding(vertical: 12, horizontal: 16)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func clippedWithPaddingAndBackground(_ material: Material) -> some View {
        self
            .padding(vertical: 12, horizontal: 16)
            .background(material)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

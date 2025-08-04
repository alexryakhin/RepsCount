//
//  ScrollView+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//
import SwiftUI

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

extension List {
    @ViewBuilder
    func scrollContentBackgroundIfAvailable(_ visibility: Visibility) -> some View {
        if #available(iOS 16, *) {
            self.scrollContentBackground(visibility)
        } else {
            self
        }
    }
}

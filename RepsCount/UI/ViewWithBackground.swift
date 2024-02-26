//
//  ViewWithBackground.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/26/24.
//

import SwiftUI

protocol ViewWithBackground: View {
    associatedtype Content: View
    associatedtype Background: View

    @ViewBuilder var content: Content { get }
    @ViewBuilder var background: Background { get }
}

extension ViewWithBackground {
    var background: some View {
        Color(uiColor: UIColor.secondarySystemBackground)
    }

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            content
        }
    }
}

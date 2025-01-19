//
//  RCContentUnavailableView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/2/24.
//

import SwiftUI

struct RCContentUnavailableView: View {

    private let title: LocalizedStringKey
    private let description: LocalizedStringKey
    private let systemImage: String

    init(
        title: LocalizedStringKey,
        description: LocalizedStringKey,
        systemImage: String
    ) {
        self.title = title
        self.description = description
        self.systemImage = systemImage
    }

    var body: some View {
        if #available(iOS 17.0, *) {
            ContentUnavailableView(
                title,
                systemImage: systemImage,
                description: Text(description)
            )
        } else {
            VStack(spacing: 12) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.secondary)
                    .frame(width: 40, height: 40, alignment: .center)
                Text(title)
                    .font(.system(.headline))
                Text(description)
                    .font(.system(.subheadline))
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    RCContentUnavailableView(title: "Error", description: "Error description", systemImage: "gear")
}

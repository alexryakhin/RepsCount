//
//  EmptyListView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct EmptyListView<Actions: View>: View {
    private let label: LocalizedStringKey?
    private let description: LocalizedStringKey?
    private let background: Color
    private let actions: () -> Actions

    init(
        label: LocalizedStringKey? = nil,
        description: LocalizedStringKey? = nil,
        background: Color = Color(.systemGroupedBackground),
        @ViewBuilder actions: @escaping () -> Actions = { EmptyView() }
    ) {
        self.label = label
        self.description = description
        self.background = background
        self.actions = actions
    }

    var body: some View {
        ZStack {
            background.ignoresSafeArea()
            if #available(iOS 17.0, *) {
                ContentUnavailableView(
                    label: {
                        if let label {
                            Text(label)
                        } else {
                            EmptyView()
                        }
                    },
                    description: {
                        if let description {
                            Text(description)
                        } else {
                            EmptyView()
                        }
                    },
                    actions: actions
                )
            } else {
                VStack(spacing: 12) {
                    if let label {
                        Text(label)
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    if let description {
                        Text(description)
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    actions()
                }
                .padding(16)
            }
        }
    }
}

#Preview {
    EmptyListView(
        label: "No idioms yet",
        description: "Begin to add idioms to your list by tapping on plus icon in upper left corner"
    )
}

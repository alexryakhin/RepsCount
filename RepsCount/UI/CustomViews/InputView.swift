//
//  InputView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/19/25.
//

import SwiftUI

struct InputView: View {
    @FocusState private var isFocused: Bool

    @Binding private var text: String
    @Binding private var error: String?
    private var header: String
    private var placeholder: String?
    private var caption: String?

    init(
        text: Binding<String>,
        error: Binding<String?> = .constant(nil),
        header: String,
        placeholder: String? = nil,
        caption: String? = nil
    ) {
        self._text = text
        self._error = error
        self.header = header
        self.placeholder = placeholder
        self.caption = caption
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(header)
                .font(.subheadline)
                .padding(.horizontal, 16)

            HStack {
                TextField(placeholder ?? "", text: $text)
                    .focused($isFocused)
                    .foregroundColor(error != nil ? .red : .primary)

                if isFocused && text != "" {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                var color: Color {
                    if isFocused {
                        return .accentColor
                    } else if error != nil {
                        return .red
                    } else {
                        return .clear
                    }
                }
                color.clipShape(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style: .init(lineWidth: 1))
                )
                .allowsHitTesting(false)
            }
            .onChange(of: text) { _ in
                if error != nil {
                    error = nil
                }
            }
            Group {
                if let error {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                } else if let caption {
                    Text(caption)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    InputView(text: .constant("123"), header: "Header")
        .padding(16)
}

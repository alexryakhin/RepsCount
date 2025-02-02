//
//  ListInputView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/19/25.
//

import SwiftUI

struct ListInputView: View {
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
        Section {
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
        } header: {
            Text(header)
        } footer: {
            if let error {
                Text(error)
                    .foregroundStyle(.red.opacity(0.8))
            } else if let caption {
                Text(caption)
            }
        }
        .listRowBackground(
            error != nil ? Color.red.opacity(0.4) : Color.surface
        )
        .onChange(of: text) {
            if error != nil {
                error = nil
            }
        }
    }
}

#Preview {
    InputView(text: .constant("123"), header: "Header")
        .padding(16)
}

//
//  DateInputView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/19/25.
//

import SwiftUI

struct DateInputView: View {
    @FocusState private var isFocused: Bool

    @Binding private var date: Date?
    @Binding private var error: String?
    private var header: String
    private var placeholder: String?
    private var caption: String?

    init(
        date: Binding<Date?>,
        error: Binding<String?> = .constant(nil),
        header: String,
        placeholder: String? = nil,
        caption: String? = nil
    ) {
        self._date = date
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
                CustomDatePicker(
                    date: $date,
                    minDate: .now,
                    maxDate: nil,
                    pickerMode: .date
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .focused($isFocused)
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
            .onChange(of: date) { _ in
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
    DateInputView(date: .constant(nil), header: "Header")
        .padding(16)
}

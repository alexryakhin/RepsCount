//
//  ListDateInputView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/19/25.
//

import SwiftUI

struct ListDateInputView: View {
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
        Section {
            CustomDatePicker(
                date: $date,
                minDate: .now,
                maxDate: nil,
                pickerMode: .date
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        } header: {
            Text(header)
        } footer: {
            if let error {
                Text(error)
                    .foregroundColor(.red.opacity(0.8))
            } else if let caption {
                Text(caption)
            }
        }
        .listRowBackground(
            error != nil ? Color.red.opacity(0.4) : Color.surface
        )
        .onChange(of: date) {
            if error != nil {
                error = nil
            }
        }
    }
}

#Preview {
    DateInputView(date: .constant(nil), header: "Header")
        .padding(16)
}

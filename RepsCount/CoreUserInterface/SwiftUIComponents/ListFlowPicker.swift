//
//  ListFlowPicker.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/26/25.
//

import Flow
import SwiftUI

struct ListFlowPicker<SelectionItem: Selectable>: View {

    @Binding private var selection: SelectionItem?
    @Binding private var error: String?
    private let items: [SelectionItem]
    private let header: String
    private let caption: String?

    init(
        selection: Binding<SelectionItem?>,
        error: Binding<String?> = .constant(nil),
        items: [SelectionItem],
        header: String,
        caption: String? = nil
    ) {
        self._selection = selection
        self._error = error
        self.items = items
        self.header = header
        self.caption = caption
    }

    var body: some View {
        Section {
            FlowPickerView(selection: $selection, items: items)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 1)
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
            error != nil ? Color.red.opacity(0.4) : Color(.secondarySystemGroupedBackground)
        )
        .onChange(of: selection) { _ in
            if error != nil {
                error = nil
            }
        }
        .animation(.default, value: selection)
    }
}

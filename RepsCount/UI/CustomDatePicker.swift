//
//  CustomDatePicker.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/27/24.
//

import Foundation
import SwiftUI

struct CustomDatePicker: View {

    enum PickerMode {
        case date
        case dateAndTime
        case time
    }

    @Binding private var date: Date?
    private let minDate: Date?
    private let maxDate: Date?
    private let pickerMode: PickerMode
    private let minuteInterval: Int

    @State private var placeholderSize: CGSize = .zero
    @State private var isEditing: Bool = false

    init(
        date: Binding<Date?>,
        minDate: Date?,
        maxDate: Date?,
        pickerMode: PickerMode,
        minuteInterval: Int = 1
    ) {
        self._date = date
        self.minDate = minDate
        self.maxDate = maxDate
        self.pickerMode = pickerMode
        self.minuteInterval = minuteInterval
    }

    private var dateSelection: Binding<Date> {
        Binding { date ?? .now }
        set: { date = $0 }
    }

    var body: some View {
        ZStack {
            DatePickerView(
                selection: dateSelection,
                isEditing: $isEditing,
                minDate: minDate,
                maxDate: maxDate,
                datePickerMode: pickerMode.mode,
                minuteInterval: minuteInterval
            )
            .opacity(0.011)
            .frame(width: placeholderSize.width, height: placeholderSize.height)
            .clipped()
            ChildSizeReader(size: $placeholderSize) {
                pickerPlaceholder(date: date)
                    .animation(.linear(duration: 0.1), value: date)
            }
            .allowsHitTesting(false)
        }
    }

    private func pickerPlaceholder(date: Date?) -> some View {
        pickerPlaceholderText(date: date)
                .foregroundColor(isEditing ? Color.accentColor : Color.primary)
                .frame(height: 24)
                .fixedSize(horizontal: true, vertical: false)
    }

    @ViewBuilder
    private func pickerPlaceholderText(date: Date?) -> some View {
        if let date {
            Text(date, style: pickerMode.textStyle)
                .bold()
        } else {
            Image(systemName: "calendar")
        }
    }
}

extension CustomDatePicker.PickerMode {
    var textStyle: Text.DateStyle {
        switch self {
        case .date: return .date
        case .dateAndTime: return .date
        case .time: return .time
        }
    }

    var mode: UIDatePicker.Mode {
        switch self {
        case .date: return .date
        case .dateAndTime: return .dateAndTime
        case .time: return .time
        }
    }
}

#Preview {
    CustomDatePicker(
        date: .constant(nil),
        minDate: nil,
        maxDate: nil,
        pickerMode: .date
    )
}

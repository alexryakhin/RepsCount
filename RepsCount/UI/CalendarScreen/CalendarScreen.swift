//
//  CalendarScreen.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/6/25.
//

import SwiftUI
import MijickCalendarView

struct CalendarScreen: View {
    @State private var selectedDate: Date? = .now
    @State private var selectedMonth: Date = .now
    @State private var selectedRange: MDateRange? = .init()

    var body: some View {
        MCalendarView(selectedDate: $selectedDate, selectedRange: $selectedRange) { calendar in
            calendar
                .firstWeekday(.monday)
                .dayView(Price.init)
                .startMonth(selectedMonth)
                .endMonth(selectedMonth)
        }
        .scrollDisabled(true)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct Price: DayView {
    let date: Date
    let isCurrentMonth: Bool
    let selectedDate: Binding<Date?>?
    let selectedRange: Binding<MDateRange?>?

    func createContent() -> AnyView {
        VStack(spacing: 16) {
            Text(getStringFromDay(format: "d"))
                .font(.body)
                .foregroundStyle(.primary)

            Text("$\((144...420).randomElement() ?? 200)")
                .font(.body)
                .foregroundStyle(.primary)
        }
        .opacity(isPast() ? 0.6 : 1)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            isPast()
            ? Color.secondary.opacity(0.5)
            : selectedDate?.wrappedValue == date ? Color.red : Color.clear
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .erased()
    }

    func onSelection() {
        if !isPast() {
            selectedDate?.wrappedValue = date
        }
    }
}

extension View {
    @ViewBuilder func active(if condition: Bool) -> some View { if condition { self } }
}

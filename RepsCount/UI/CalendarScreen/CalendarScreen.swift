//
//  CalendarScreen.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/6/25.
//

import SwiftUI
import MijickCalendarView

struct CalendarScreen: View {
    private let resolver = DIContainer.shared.resolver

    @State private var selectedDate: Date? = .now
    @State private var selectedMonth: Date = .now
    @State private var selectedRange: MDateRange? = .init()

    var body: some View {
        NavigationView {
            VStack {
                MCalendarView(
                    selectedDate: $selectedDate,
                    selectedRange: $selectedRange
                ) { calendar in
                    calendar
                        .firstWeekday(.monday)
                        .dayView(Price.init)
                        .startMonth(selectedMonth)
                        .endMonth(selectedMonth)
                        .monthLabel(MyMonthLabel.init)
                }
                .scrollDisabled(true)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)

                ScrollView {
                    ForEach(0..<18) { _ in
                        HStack {
                            Text("Item")

                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Add event") {
                        resolver.resolve(PlanWorkoutScreen.self)!
                    }
                    .buttonStyle(.bordered)
                }
            }
            .background {
                Color.background.ignoresSafeArea()
            }
        }

    }
}

struct Price: DayView {
    let date: Date
    let isCurrentMonth: Bool
    let selectedDate: Binding<Date?>?
    let selectedRange: Binding<MDateRange?>?

    var isSelected: Bool {
        date.trimmed() == selectedDate?.wrappedValue?.trimmed()
    }

    func createContent() -> AnyView {
        VStack(spacing: 4) {
            Text(getStringFromDay(format: "d"))
                .font(.headline)
                .foregroundStyle(.primary)

            dotsGridView
        }
        .opacity(isPast() ? 0.5 : 1)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.surface)
        .overlay {
            (isSelected ? Color.accentColor : .clear)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(style: .init(lineWidth: 4))
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(2)
        .erased()
    }

    func onSelection() {
        if !isPast() {
            selectedDate?.wrappedValue = date
        }
    }

    private var dotsGridView: some View {
        LazyHGrid(rows: Array(repeating: GridItem(.flexible(minimum: 4, maximum: 4)), count: 2), spacing: 4) {
            ForEach(0..<Int.random(in: 1...8)) { _ in
                Circle()
                    .fill(Color.red)
                    .frame(width: 5, height: 5)
            }
        }
        .padding(.horizontal, 8)
    }
}

struct MyMonthLabel: MonthLabel {
    var month: Date

    func createContent() -> AnyView {
        Text(month.formatted(
            Date.FormatStyle()
                .year(.defaultDigits)
                .month(.wide)
        ))
        .font(.system(.title, design: .default, weight: .bold))
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .erased()
    }
}

extension View {
    @ViewBuilder func active(if condition: Bool) -> some View { if condition { self } }
}

#Preview {
    DIContainer.shared.resolver.resolve(CalendarScreen.self)!
}

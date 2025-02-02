//
//  RecurrenceRulePickerView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/2/25.
//

import SwiftUI
import Foundation

@available(iOS 18, *)
struct RecurrenceRulePickerView: View {
    @Environment(\.dismiss) private var dismiss
    let existingRule: Calendar.RecurrenceRule?
    let completion: (Calendar.RecurrenceRule?) -> Void

    // State variables
    @State private var frequency: Calendar.RecurrenceRule.Frequency = .daily
    @State private var interval: Int = 1
    @State private var selectedDaysOfWeek: Set<Locale.Weekday> = []
    @State private var selectedDaysOfMonth: Set<Int> = []
    @State private var endCondition: RecurrenceEnd = .never
    @State private var endDate: Date = Calendar.current.date(byAdding: .month, value: 3, to: Date())!
    @State private var occurrenceCount: Int = 10

    enum RecurrenceEnd: String, CaseIterable {
        case never = "Never"
        case untilDate = "Until a specific date"
        case occurrenceCount = "After a number of occurrences"
    }

    init(existingRule: Calendar.RecurrenceRule? = nil, completion: @escaping (Calendar.RecurrenceRule?) -> Void) {
        self.existingRule = existingRule
        self.completion = completion

        // Preload state if an existing rule is provided
        if let rule = existingRule {
            _frequency = State(initialValue: rule.frequency)
            _interval = State(initialValue: rule.interval)
            _selectedDaysOfWeek = State(initialValue: Set(rule.weekdays.compactMap { if case .every(let day) = $0 { return day } else { return nil } }))
            _selectedDaysOfMonth = State(initialValue: Set(rule.daysOfTheMonth))

//            if let endRule = rule.end {
//                switch endRule {
//                case .afterDate(let date):
//                    _endCondition = State(initialValue: .untilDate)
//                    _endDate = State(initialValue: date)
//                case .afterOccurrences(let count):
//                    _endCondition = State(initialValue: .occurrenceCount)
//                    _occurrenceCount = State(initialValue: count)
//                default:
//                    _endCondition = State(initialValue: .never)
//                }
//            }
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Repeat Every")) {
                Picker("Frequency", selection: $frequency) {
                    Text("Daily").tag(Calendar.RecurrenceRule.Frequency.daily)
                    Text("Weekly").tag(Calendar.RecurrenceRule.Frequency.weekly)
                    Text("Monthly").tag(Calendar.RecurrenceRule.Frequency.monthly)
                    Text("Yearly").tag(Calendar.RecurrenceRule.Frequency.yearly)
                }
                .pickerStyle(SegmentedPickerStyle())

                Stepper("Every \(interval) \(unitName(interval))", value: $interval, in: 1...30)
            }

            if frequency == .weekly {
                Section(header: Text("Repeat On")) {
                    WeekdaySelectionView(selectedDays: $selectedDaysOfWeek)
                }
            }

            if frequency == .monthly {
                Section(header: Text("Days of the Month")) {
                    MultiSelectGrid(items: Array(1...31), selectedItems: $selectedDaysOfMonth)
                }
            }

            Section(header: Text("End Condition")) {
                Picker("End Condition", selection: $endCondition) {
                    ForEach(RecurrenceEnd.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(MenuPickerStyle())

                if endCondition == .untilDate {
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }

                if endCondition == .occurrenceCount {
                    Stepper("After \(occurrenceCount) occurrences", value: $occurrenceCount, in: 1...100)
                }
            }

            Section {
                Button("Remove Recurrence", role: .destructive) {
                    completion(nil) // Pass nil to remove recurrence
                    dismiss()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Repeat Event")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    completion(buildRecurrenceRule())
                    dismiss()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }

    private func unitName(_ count: Int) -> String {
        switch frequency {
        case .daily: return count == 1 ? "day" : "days"
        case .weekly: return count == 1 ? "week" : "weeks"
        case .monthly: return count == 1 ? "month" : "months"
        case .yearly: return count == 1 ? "year" : "years"
        @unknown default: return "interval"
        }
    }

    private func buildRecurrenceRule() -> Calendar.RecurrenceRule {
        let endRule: Calendar.RecurrenceRule.End? = {
            switch endCondition {
            case .never: return .never
            case .untilDate: return .afterDate(endDate)
            case .occurrenceCount: return .afterOccurrences(occurrenceCount)
            }
        }()

        return Calendar.RecurrenceRule(
            calendar: Calendar.current,
            frequency: frequency,
            interval: interval,
            end: endRule ?? .never,
            daysOfTheMonth: Array(selectedDaysOfMonth),
            weekdays: selectedDaysOfWeek.map { .every($0) }
        )
    }
}

// ✅ Custom Grid for Monthly Day Selection
@available(iOS 18, *)
struct MultiSelectGrid: View {
    let items: [Int]
    @Binding var selectedItems: Set<Int>

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 30)), count: 7)) {
            ForEach(items, id: \.self) { item in
                Text("\(item)")
                    .frame(width: 30, height: 30)
                    .background(selectedItems.contains(item) ? Color.blue : Color.clear)
                    .cornerRadius(5)
                    .onTapGesture {
                        if selectedItems.contains(item) {
                            selectedItems.remove(item)
                        } else {
                            selectedItems.insert(item)
                        }
                    }
            }
        }
    }
}

// ✅ Weekday Picker
@available(iOS 18, *)
struct WeekdaySelectionView: View {
    let weekdays: [Locale.Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    @Binding var selectedDays: Set<Locale.Weekday>

    var body: some View {
        HStack {
            ForEach(weekdays, id: \.self) { day in
                Text(day.rawValue)
                    .frame(width: 30, height: 30)
                    .background(selectedDays.contains(day) ? Color.blue : Color.clear)
                    .cornerRadius(5)
                    .onTapGesture {
                        if selectedDays.contains(day) {
                            selectedDays.remove(day)
                        } else {
                            selectedDays.insert(day)
                        }
                    }
            }
        }
    }
}

@available(iOS 18, *)
func recurrenceRuleDescription(_ rule: Calendar.RecurrenceRule) -> String {
    let calendar = Calendar.current
    var components: [String] = []

    // Frequency (Daily, Weekly, Monthly, Yearly)
    switch rule.frequency {
    case .daily:
        components.append("Every \(rule.interval == 1 ? "day" : "\(rule.interval) days")")
    case .weekly:
        if !rule.weekdays.isEmpty {
            let days = rule.weekdays.map { weekdayToString($0) }.joined(separator: ", ")
            components.append("Every \(rule.interval == 1 ? "" : "\(rule.interval) weeks on ")\(days)")
        } else {
            components.append("Every \(rule.interval == 1 ? "week" : "\(rule.interval) weeks")")
        }
    case .monthly:
        if !rule.daysOfTheMonth.isEmpty {
            let days = rule.daysOfTheMonth.map { ordinalSuffix($0) }.joined(separator: ", ")
            components.append("Every \(rule.interval == 1 ? "month" : "\(rule.interval) months") on the \(days)")
        } else {
            components.append("Every \(rule.interval == 1 ? "month" : "\(rule.interval) months")")
        }
    case .yearly:
        components.append("Every \(rule.interval == 1 ? "year" : "\(rule.interval) years")")
    default:
        components.append("Custom Recurrence")
    }

    // End Condition
    components.append(", ends \(rule.end)")

    return components.joined(separator: " ")
}

@available(iOS 18, *)
func weekdayToString(_ weekday: Calendar.RecurrenceRule.Weekday) -> String {
    switch weekday {
    case .every(let day):
        return day.rawValue
    case .nth(let index, let day):
        return "\(ordinalSuffix(index)) \(day.rawValue)"
    }
}

func ordinalSuffix(_ number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    return formatter.string(from: NSNumber(value: number)) ?? ""
}

extension Calendar {
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

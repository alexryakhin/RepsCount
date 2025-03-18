//
//  WorkoutEvent.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation
import EventKit
import Shared

/// Defines the type of a workoutEvent.
public enum WorkoutEventType: Int, Hashable, CaseIterable, Identifiable, Codable {
    public var id: Int { rawValue }

    case single = 1
    case recurring = 2
}

public enum WorkoutEventDay: Int, Hashable, CaseIterable, Identifiable, Codable {
    public var id: Int { rawValue }

    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    public var name: String {
        switch self {
            case .sunday: return "Sunday"
            case .monday: return  "Monday"
            case .tuesday: return "Tuesday"
            case .wednesday: return "Wednesday"
            case .thursday: return "Thursday"
            case .friday: return "Friday"
            case .saturday: return "Saturday"
        }
    }

    public var weekDay: EKWeekday {
        switch self {
            case .monday: return .monday
            case .tuesday: return .tuesday
            case .wednesday: return .wednesday
            case .thursday: return .thursday
            case .friday: return .friday
            case .sunday: return .sunday
            case .saturday: return .saturday
        }
    }

    public var dayOfWeek: EKRecurrenceDayOfWeek {
        return EKRecurrenceDayOfWeek(self.weekDay)
    }
}

public enum WorkoutEventRecurrence: Int, Hashable, CaseIterable, Identifiable, Codable {
    public var id: Int { rawValue }

    case daily = 0
    case weekly = 1
    case monthly = 2

    public var frequency: EKRecurrenceFrequency {
        switch self {
        case .daily: return .daily
        case .weekly: return .weekly
        case .monthly: return .monthly
        }
    }
}

/// Provides information about a workoutEvent.
public struct WorkoutEvent: Identifiable, Hashable {
    public var id: String { name }

    /// Specifies whether the workoutEvent is a recurring event or a single event.
    var type: WorkoutEventType
    var name: String

    /// Specifies the days on which the workoutEvent occur.
    var days: [WorkoutEventDay]

    /// Specifies the time at which the workoutEvent starts.
    var startAt: Int

    /// Specifies the workoutEvent recurrence frequency.
    var repeats: WorkoutEventRecurrence?

    /// Specifies the workoutEvent recurrence interval.
    var interval: Int?

    /// Specifies how often the workoutEvent occurs.
    var occurrenceCount: Int?

    public init(
        type: WorkoutEventType,
        name: String,
        days: [WorkoutEventDay],
        startAt: Int,
        repeats: WorkoutEventRecurrence? = nil,
        interval: Int? = nil,
        occurrenceCount: Int? = nil
    ) {
        self.type = type
        self.name = name
        self.days = days
        self.startAt = startAt
        self.repeats = repeats
        self.interval = interval
        self.occurrenceCount = occurrenceCount
    }
}

public extension WorkoutEvent {
    var title: String {
        return "Swim " + name
    }

    var titleAndBook: String {
        return "Book \(title)"
    }

    var titleAndStartAt: String {
        return "Book \(self.title) starting at \(self.startAtDate.formatted(date: .omitted, time: .shortened))"
    }
}

extension WorkoutEvent: Equatable {
    public static func ==(lhs: WorkoutEvent, rhs: WorkoutEvent) -> Bool {
        lhs.id == rhs.id
    }
}

public extension WorkoutEvent {
    static var dropinWorkoutEventMock: WorkoutEvent {
        WorkoutEvent(type: .single, name: "205", days: [.monday], startAt: 43_200)
    }

    static var repeatingWorkoutEventMock: WorkoutEvent {
        WorkoutEvent(type: .recurring, name: "105", days: [.friday], startAt: 39_900, repeats: .weekly, interval: 1, occurrenceCount: 8)
    }
}

public extension WorkoutEvent {
    var startAtDate: Date {
        return TimeInterval(startAt).toTodayDate
    }

    var endAtDate: Date {
        return startAtDate.thirtyMinutesLater
    }

    var fromStartAtToEndAtAsText: String {
        return "\(startAtDate.timeAsText) to \(endAtDate.timeAsText)"
    }

    var daysAsText: String {
        return days.map({ (day: WorkoutEventDay) in day.name }).joined(separator: " and ")
    }
}

public extension WorkoutEvent {
    /// Create the date at which a drop-in workoutEvent starts.
    func workoutEventWithDate(date: Date) -> Date {
        let result = TimeInterval(startAt)
        return Calendar.current.date(bySettingHour: result.hour, minute: result.minute, second: 0, of: date) ?? date
    }

    /// Fetch the next date that occurs after the currently selected day.
    func nextDateMatchingScheduledWorkoutEvents(date: Date) -> Date {
        let indexSet = IndexSet(self.days.map({ (item: WorkoutEventDay) in item.dayOfWeek.dayOfTheWeek.rawValue }))
        let result = date.fetchNextDateFromDays(indexSet)

        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .month], from: result)
        components.hour = TimeInterval(startAt).hour
        components.minute = TimeInterval(startAt).minute
        return Calendar.current.date(from: components) ?? Date()
    }

    /// Create the date at which a workoutEvent begins.
    func buildStartDate(date: Date) -> Date {
        switch type {
        case .single:
            return workoutEventWithDate(date: date)
        case .recurring:
            return nextDateMatchingScheduledWorkoutEvents(date: date)
        }
    }

    /// Create an event with the workoutEvent details. Use the user's default calendar if the specified calendar doesn't exist.
    func eventWithDate(_ date: Date, store: EKEventStore, calendar: EKCalendar? = nil) -> EKEvent {
        let startDate = buildStartDate(date: date)
        let endDate = startDate.thirtyMinutesLater

        let newEvent = EKEvent(
            workoutEvent: self,
            eventStore: store,
            calendar: calendar ?? store.defaultCalendarForNewEvents,
            startDate: startDate,
            endDate: endDate
        )

        return newEvent
    }
}

public extension WorkoutEvent {
    /// Formats the number of recurring workoutEvent occurrences.
    var numberOfRecurringWorkoutEvents: String {
        guard let workoutEventCount = occurrenceCount else {
            fatalError()
        }
        return "No. of workoutEvents: \(workoutEventCount)"
    }

    /// The amount of occurrences of a recurring workoutEvent.
    var recurrenceEnd: EKRecurrenceEnd {
        guard let occurrenceCount else { fatalError("Can't create recurrence end") }
        return EKRecurrenceEnd(occurrenceCount: occurrenceCount)
    }

    /// Specifies when a recurring workoutEvent ends.
    var recurrenceRule: EKRecurrenceRule {
        let recurrenceDayOfWeek = days.map(\.dayOfWeek)
        guard let repeats, let interval else { fatalError("Can't create recurrence rule") }

        return EKRecurrenceRule(
            recurrenceWith: repeats.frequency,
            interval: interval,
            daysOfTheWeek: recurrenceDayOfWeek,
            daysOfTheMonth: nil,
            monthsOfTheYear: nil,
            weeksOfTheYear: nil,
            daysOfTheYear: nil,
            setPositions: nil,
            end: recurrenceEnd
        )
    }
}

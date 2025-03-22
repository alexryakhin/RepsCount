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

/// Defines the type of a workout event.
public enum WorkoutEventType: Int, Hashable, CaseIterable, Identifiable {
    public var id: Int { rawValue }

    case single = 0
    case recurring = 1
}

/// Defines the duration of a workout event.
public enum WorkoutEventDuration: Int, Hashable, CaseIterable, Identifiable {
    public var id: Int { rawValue }

    case fifteenMinutes = 0
    case thirtyMinutes = 1
    case oneHour = 2
    case oneHourAndThirtyMinutes = 3
    case twoHours = 4

    public var timeInterval: TimeInterval {
        switch self {
        case .fifteenMinutes: return 900
        case .thirtyMinutes: return 1800
        case .oneHour: return 3600
        case .oneHourAndThirtyMinutes: return 3600 + 1800
        case .twoHours: return 7200
        }
    }

    public var localizedName: String {
        switch self {
        case .fifteenMinutes: return NSLocalizedString("15 minutes", comment: .empty)
        case .thirtyMinutes: return NSLocalizedString("30 minutes", comment: .empty)
        case .oneHour: return NSLocalizedString("1 hour", comment: .empty)
        case .oneHourAndThirtyMinutes: return NSLocalizedString("1 hour 30 minutes", comment: .empty)
        case .twoHours: return NSLocalizedString("2 hours", comment: .empty)
        }
    }
}

public enum WorkoutEventDay: Int, Hashable, CaseIterable, Identifiable {
    public var id: Int { rawValue }

    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6

    public var localizedName: String {
        switch self {
            case .sunday: return NSLocalizedString("Sunday", comment: .empty)
            case .monday: return  NSLocalizedString("Monday", comment: .empty)
            case .tuesday: return NSLocalizedString("Tuesday", comment: .empty)
            case .wednesday: return NSLocalizedString("Wednesday", comment: .empty)
            case .thursday: return NSLocalizedString("Thursday", comment: .empty)
            case .friday: return NSLocalizedString("Friday", comment: .empty)
            case .saturday: return NSLocalizedString("Saturday", comment: .empty)
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

public enum WorkoutEventRecurrence: Int, Hashable, CaseIterable, Identifiable {
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

/// Provides information about a workout event.
public struct WorkoutEvent: Identifiable, Hashable {
    public let id: String

    /// Template selected for the event
    public let template: WorkoutTemplate

    /// Specifies whether the workout event is a recurring event or a single event.
    public var type: WorkoutEventType {
        recurrenceId == nil ? .single : .recurring
    }

    /// Specifies the days on which the workout event occur.
    public let days: [WorkoutEventDay]

    /// Specifies the time at which the workout event starts.
    public let startAt: Int

    /// Specifies the workout event recurrence frequency.
    public let repeats: WorkoutEventRecurrence?

    /// Specifies the workout event recurrence interval.
    public let interval: Int?

    /// Specifies how often the workout event occurs.
    public let occurrenceCount: Int?

    /// If event is recurring, then it will have this id
    public let recurrenceId: String?

    /// Specifies the duration of the workout
    public let duration: WorkoutEventDuration

    /// Specifies the date of the event.
    public let date: Date

    /// The id of the workout if user actually started a workout based on the event. One to one connection
    public let workoutInstanceId: String?

    public init(
        template: WorkoutTemplate,
        days: [WorkoutEventDay],
        startAt: Int,
        repeats: WorkoutEventRecurrence?,
        interval: Int?,
        occurrenceCount: Int?,
        duration: WorkoutEventDuration,
        date: Date,
        id: String = UUID().uuidString,
        recurrenceId: String?,
        workoutInstanceId: String? = nil
    ) {
        self.template = template
        self.days = days
        self.startAt = startAt
        self.repeats = repeats
        self.interval = interval
        self.occurrenceCount = occurrenceCount
        self.duration = duration
        self.date = date
        self.id = id
        self.recurrenceId = recurrenceId
        self.workoutInstanceId = workoutInstanceId
    }
}

extension WorkoutEvent: Equatable {
    public static func ==(lhs: WorkoutEvent, rhs: WorkoutEvent) -> Bool {
        lhs.id == rhs.id
    }
}

public extension WorkoutEvent {
    var endAtDate: Date {
        Date(timeInterval: duration.timeInterval, since: date)
    }
}

public extension WorkoutEvent {
    /// Create the date at which a drop-in workout event starts.
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

    /// Create the date at which a workout event begins.
    func buildStartDate(date: Date) -> Date {
        switch type {
        case .single:
            return workoutEventWithDate(date: date)
        case .recurring:
            return nextDateMatchingScheduledWorkoutEvents(date: date)
        }
    }

    /// Create an event with the workout event details. Use the user's default calendar if the specified calendar doesn't exist.
    func event(store: EKEventStore, calendar: EKCalendar? = nil) -> EKEvent {
        let startDate = buildStartDate(date: date)
        let endDate = Date(timeInterval: duration.timeInterval, since: startDate)

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
    /// The amount of occurrences of a recurring workout event.
    var recurrenceEnd: EKRecurrenceEnd {
        guard let occurrenceCount else { fatalError("Can't create recurrence end") }
        return EKRecurrenceEnd(occurrenceCount: occurrenceCount)
    }

    /// Specifies when a recurring workout event ends.
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

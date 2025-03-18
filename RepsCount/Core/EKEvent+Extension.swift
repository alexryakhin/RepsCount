//
//  EKEvent+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/18/25.
//

import EventKit

extension EKEvent {
    /// Creates a nonfloating event that uses the specified workoutEvent, event store, calendar, start date, and end date.
    convenience init(workoutEvent: WorkoutEvent, eventStore store: EKEventStore, calendar: EKCalendar?, startDate: Date, endDate: Date) {
        self.init(eventStore: store)
        self.title = workoutEvent.title
        self.calendar = calendar
        self.startDate = startDate
        self.endDate = endDate

        // A floating event is one that isn't associated with a specific time zone. Set `timeZone` to nil if you wish to have a floating event.
        self.timeZone = TimeZone.current

        if workoutEvent.type == .recurring {
            self.addRecurrenceRule(workoutEvent.recurrenceRule)
        }
    }
}

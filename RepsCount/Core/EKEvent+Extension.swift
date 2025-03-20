//
//  EKEvent+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/18/25.
//

import EventKit

extension EKEvent {
    /// Creates a nonfloating event that uses the specified workout event, event store, calendar, start date, and end date.
    convenience init(workoutEvent: WorkoutEvent, eventStore store: EKEventStore, calendar: EKCalendar?, startDate: Date, endDate: Date) {
        self.init(eventStore: store)
        self.title = workoutEvent.template.name
        self.calendar = calendar
        self.startDate = startDate
        self.endDate = endDate
        // TODO: add ui for this later
        self.addAlarm(.init(relativeOffset: -900)) // Alert 15 minutes before a workout
        self.timeZone = TimeZone.current

        if workoutEvent.type == .recurring {
            self.addRecurrenceRule(workoutEvent.recurrenceRule)
        }
    }
}

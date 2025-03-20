//
//  WorkoutEventManager.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/7/25.
//

import CoreData
import Core

public protocol WorkoutEventManagerInterface {
    func createNewWorkoutEvent(from event: WorkoutEvent) throws(CoreError)
}

public final class WorkoutEventManager: WorkoutEventManagerInterface {

    private let coreDataService: CoreDataServiceInterface

    public init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
    }

    public func createNewWorkoutEvent(from event: WorkoutEvent) throws(CoreError) {
        guard let workoutTemplate = try getWorkoutTemplate(id: event.template.id) else {
            throw CoreError.internalError(.templateNotFound)
        }

        let generatedEvents = generateOccurrences(from: event)

        for occurrence in generatedEvents {
            let newEvent = CDWorkoutEvent(context: coreDataService.context)
            newEvent.id = UUID().uuidString
            newEvent.workoutTemplate = workoutTemplate
            newEvent.startAt = occurrence.startAt.int64
            newEvent.duration = occurrence.duration.rawValue.int64
            newEvent.date = occurrence.date
            newEvent.recurrenceId = occurrence.recurrenceId

            workoutTemplate.addToWorkoutEvents(newEvent)
        }

        try coreDataService.saveContext()
    }

    private func getWorkoutTemplate(id: String) throws(CoreError) -> CDWorkoutTemplate? {
        let fetchRequest: NSFetchRequest<CDWorkoutTemplate> = CDWorkoutTemplate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let template = try coreDataService.context.fetch(fetchRequest).first else {
                return nil
            }
            return template
        } catch {
            throw CoreError.internalError(.templateNotFound)
        }
    }

    private func generateOccurrences(from event: WorkoutEvent) -> [WorkoutEvent] {
        guard event.type == .recurring,
              let recurrence = event.repeats,
              let interval = event.interval,
              let occurrenceCount = event.occurrenceCount
        else { return [event] } // Single event, return as is.

        var occurrences: [WorkoutEvent] = []
        let calendar = Calendar.current
        var currentDate = event.date
        var count = 0

        while count < occurrenceCount {
            switch recurrence {
            case .daily:
                occurrences.append(createOccurrence(from: event, date: currentDate))
                currentDate = calendar.date(byAdding: .day, value: interval, to: currentDate) ?? currentDate
                count += 1
            case .weekly:
                // Generate occurrences for each selected day within the weekly interval
                let selectedWeekdays = event.days.map { $0.weekDay.rawValue }

                for weekday in selectedWeekdays {
                    if let nextDate = calendar.nextDate(after: currentDate, matching: DateComponents(weekday: weekday), matchingPolicy: .nextTime) {
                        occurrences.append(createOccurrence(from: event, date: nextDate))
                        count += 1
                        if count >= occurrenceCount { break }
                    }
                }
                // Move to the next week after processing all selected days
                currentDate = calendar.date(byAdding: .weekOfYear, value: interval, to: currentDate) ?? currentDate

            case .monthly:
                occurrences.append(createOccurrence(from: event, date: currentDate))
                currentDate = calendar.date(byAdding: .month, value: interval, to: currentDate) ?? currentDate
                count += 1
            @unknown default:
                fatalError("Unsupported recurrence")
            }
        }

        return occurrences
    }

    private func createOccurrence(from event: WorkoutEvent, date: Date) -> WorkoutEvent {
        let startsAtDate = Date(timeInterval: TimeInterval(event.startAt), since: date.startOfDay)
        return WorkoutEvent(
            template: event.template,
            days: [],
            startAt: event.startAt,
            repeats: nil,
            interval: nil,
            occurrenceCount: nil,
            duration: event.duration,
            date: startsAtDate,
            recurrenceId: event.recurrenceId
        )
    }
}

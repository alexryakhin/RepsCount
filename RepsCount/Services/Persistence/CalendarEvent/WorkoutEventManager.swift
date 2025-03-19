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
            newEvent.days = occurrence.days.map({ String($0.rawValue) }).joined(separator: ";")
            newEvent.startAt = occurrence.startAt.int64
            newEvent.repeats = occurrence.repeats?.rawValue.int64 ?? -1
            newEvent.interval = occurrence.interval?.int64 ?? -1
            newEvent.occurrenceCount = occurrence.occurrenceCount?.int64 ?? -1
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

        for _ in 0..<occurrenceCount {
            let newEvent = WorkoutEvent(
                template: event.template,
                days: [],
                startAt: event.startAt,
                repeats: nil,
                interval: nil,
                occurrenceCount: nil,
                duration: event.duration,
                date: currentDate,
                recurrenceId: event.recurrenceId
            )
            occurrences.append(newEvent)

            // Calculate next occurrence
            switch recurrence {
            case .daily:
                currentDate = calendar.date(byAdding: .day, value: interval, to: currentDate) ?? currentDate
            case .weekly:
                currentDate = calendar.date(byAdding: .weekOfYear, value: interval, to: currentDate) ?? currentDate
            case .monthly:
                currentDate = calendar.date(byAdding: .month, value: interval, to: currentDate) ?? currentDate
            @unknown default:
                fatalError("Unsupported recurrence")
            }
        }

        return occurrences
    }
}

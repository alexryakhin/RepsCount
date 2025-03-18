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
        let newEvent = CDWorkoutEvent(context: coreDataService.context)
        newEvent.workoutTemplate = workoutTemplate
        newEvent.type = event.type.rawValue.int64
        newEvent.days = event.days.map({ String($0.rawValue) }).joined(separator: ";")
        newEvent.startAt = event.startAt.int64
        newEvent.repeats = event.repeats?.rawValue.int64 ?? -1
        newEvent.interval = event.interval?.int64 ?? -1
        newEvent.occurrenceCount = event.occurrenceCount?.int64 ?? -1
        newEvent.duration = event.duration.rawValue.int64
        newEvent.dateCreated = event.dateCreated
        workoutTemplate.workoutEvent = newEvent
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
}

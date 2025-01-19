//
//  EventStorageInterface.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/7/25.
//

import Combine
import CoreData

protocol CalendarEventStorageInterface {
    var eventsPublisher: AnyPublisher<[CalendarEvent], CoreError> { get }
    func addEvent(title: String, date: Date, notes: String?, exercises: Set<ExerciseModel>) throws
    func deleteEvent(_ event: CalendarEvent) throws
    func fetchEvents()
}

class CalendarEventStorage: CalendarEventStorageInterface {
    private let coreDataService: CoreDataServiceInterface
    private let eventsSubject = CurrentValueSubject<[CalendarEvent], CoreError>([])
    var eventsPublisher: AnyPublisher<[CalendarEvent], CoreError> {
        eventsSubject.eraseToAnyPublisher()
    }

    init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
        fetchEvents()
    }

    func fetchEvents() {
        let request = NSFetchRequest<CalendarEvent>(entityName: "CalendarEvent")
        do {
            let events = try coreDataService.context.fetch(request)
            eventsSubject.send(events)
        } catch {
            eventsSubject.send(completion: .failure(.storageError(.readFailed)))
        }
    }

    func addEvent(title: String, date: Date, notes: String?, exercises: Set<ExerciseModel>) throws {
        let newEvent = CalendarEvent(context: coreDataService.context)
        newEvent.id = UUID().uuidString
        newEvent.title = title
        newEvent.date = date
        newEvent.notes = notes
        newEvent.exercises = NSSet(set: exercises)
        try save()
    }

    func deleteEvent(_ event: CalendarEvent) throws {
        coreDataService.context.delete(event)
        try save()
    }

    private func save() throws {
        try coreDataService.saveContext()
        fetchEvents()
    }
}

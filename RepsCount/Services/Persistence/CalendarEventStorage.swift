//
//  EventStorageInterface.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/7/25.
//

import Combine
import CoreData
import Core

//protocol CalendarEventStorageInterface {
//    var eventsPublisher: AnyPublisher<[CDCalendarEvent], CoreError> { get }
//    func addEvent(title: String, date: Date, notes: String?, exercises: Set<ExerciseModel>) throws
//    func deleteEvent(_ event: CDCalendarEvent) throws
//    func fetchEvents()
//}
//
//final class CalendarEventStorage: CalendarEventStorageInterface {
//    private let coreDataService: CoreDataServiceInterface
//    private let eventsSubject = CurrentValueSubject<[CDCalendarEvent], CoreError>([])
//    var eventsPublisher: AnyPublisher<[CDCalendarEvent], CoreError> {
//        eventsSubject.eraseToAnyPublisher()
//    }
//
//    init(coreDataService: CoreDataServiceInterface) {
//        self.coreDataService = coreDataService
//        fetchEvents()
//    }
//
//    func fetchEvents() {
//        let request = NSFetchRequest<CDCalendarEvent>(entityName: "CalendarEvent")
//        do {
//            let events = try coreDataService.context.fetch(request)
//            eventsSubject.send(events)
//        } catch {
//            eventsSubject.send(completion: .failure(.storageError(.readFailed)))
//        }
//    }
//
//    func addEvent(title: String, date: Date, notes: String?, exercises: Set<ExerciseModel>) throws {
//        let newEvent = CDCalendarEvent(context: coreDataService.context)
//        newEvent.id = UUID().uuidString
//        newEvent.title = title
//        newEvent.date = date
//        newEvent.notes = notes
//        newEvent.exercises = exercises.map(\.rawValue).joined(separator: ";")
//        try save()
//    }
//
//    func deleteEvent(_ event: CDCalendarEvent) throws {
//        coreDataService.context.delete(event)
//        try save()
//    }
//
//    private func save() throws {
//        try coreDataService.saveContext()
//        fetchEvents()
//    }
//}

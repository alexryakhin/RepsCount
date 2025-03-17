//
//  CalendarEventManager.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/7/25.
//

import Combine
import CoreData
import Core

protocol CalendarEventManagerInterface {
    var calendarEventPublisher: AnyPublisher<CalendarEvent?, Never> { get }
    var errorPublisher: PassthroughSubject<CoreError, Never> { get }

    func createNewCalendarEvent(
        title: String,
        date: Date,
        notes: String?,
        recurrenceRule: String?,
        workoutTemplateId: String
    )
}

final class CalendarEventManager: CalendarEventManagerInterface {
    public var calendarEventPublisher: AnyPublisher<CalendarEvent?, Never> {
        calendarEventSubject.eraseToAnyPublisher()
    }
    public let errorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface

    private let calendarEventSubject = CurrentValueSubject<CalendarEvent?, Never>(nil)
    private var cdCalendarEvent: CDCalendarEvent?
    private var cancellables: Set<AnyCancellable> = []

    init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
    }

    func createNewCalendarEvent(
        title: String,
        date: Date,
        notes: String?,
        recurrenceRule: String?,
        workoutTemplateId: String
    ) {
        guard let workoutTemplate = getWorkoutTemplate(id: workoutTemplateId) else { return }
        let newEvent = CDCalendarEvent(context: coreDataService.context)
        newEvent.id = UUID().uuidString
        newEvent.title = title
        newEvent.date = date
        newEvent.notes = notes
        newEvent.recurrenceRule = recurrenceRule
        newEvent.workoutTemplate = workoutTemplate
        saveContext()
    }

    private func getWorkoutTemplate(id: String) -> CDWorkoutTemplate? {
        let fetchRequest: NSFetchRequest<CDWorkoutTemplate> = CDWorkoutTemplate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        guard let template = try? coreDataService.context.fetch(fetchRequest).first else {
            return nil
        }
        return template
    }

    private func saveContext() {
        do {
            try coreDataService.saveContext()
        } catch {
            errorPublisher.send(.storageError(.saveFailed))
        }
    }
}

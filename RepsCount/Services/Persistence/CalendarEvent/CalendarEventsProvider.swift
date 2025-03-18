//
//  CalendarEventStorageInterface.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/7/25.
//

import Combine
import CoreData
import Core

public protocol CalendarEventsProviderInterface {
    var eventsPublisher: AnyPublisher<[CalendarEvent], Never> { get }
    var eventsErrorPublisher: PassthroughSubject<CoreError, Never> { get }

    func delete(with id: String)
    func fetchEvents()
}

public final class CalendarEventsProvider: CalendarEventsProviderInterface {

    public var eventsPublisher: AnyPublisher<[CalendarEvent], Never> {
        return eventsSubject.eraseToAnyPublisher()
    }

    public let eventsErrorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface
    private let eventsSubject = CurrentValueSubject<[CalendarEvent], Never>([])
    private var cancellables: Set<AnyCancellable> = []

    public init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
        setupBindings()
        coreDataService.context.refreshAllObjects()
    }

    public func fetchEvents() {
        let request = CDCalendarEvent.fetchRequest()
        do {
            let events = try coreDataService.context.fetch(request)
            eventsSubject.send(events.compactMap(\.coreModel))
        } catch {
            eventsErrorPublisher.send(.storageError(.readFailed))
        }
    }

    public func delete(with id: String) {
        let request = CDCalendarEvent.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            if let object = try coreDataService.context.fetch(request).first {
                coreDataService.context.delete(object)
                try coreDataService.saveContext()
            } else {
                throw CoreError.internalError(.removingEventFailed)
            }
        } catch {
            eventsErrorPublisher.send(.internalError(.removingEventFailed))
        }
    }

    private func setupBindings() {
        NotificationCenter.default.eventChangedPublisher
            .combineLatest(NotificationCenter.default.coreDataDidSaveObjectIDsPublisher)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchEvents()
            }
            .store(in: &cancellables)
    }
}

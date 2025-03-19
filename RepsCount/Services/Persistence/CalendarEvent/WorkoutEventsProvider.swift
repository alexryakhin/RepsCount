//
//  WorkoutEventStorageInterface.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/7/25.
//

import Combine
import CoreData
import Core

public protocol WorkoutEventsProviderInterface {
    var eventsPublisher: AnyPublisher<[WorkoutEvent], Never> { get }
    var eventsErrorPublisher: PassthroughSubject<CoreError, Never> { get }

    func deleteEvent(_ event: WorkoutEvent, shouldDeleteAllFutureEvents: Bool)
    func fetchEvents()
}

public final class WorkoutEventsProvider: WorkoutEventsProviderInterface {

    public var eventsPublisher: AnyPublisher<[WorkoutEvent], Never> {
        return eventsSubject.eraseToAnyPublisher()
    }

    public let eventsErrorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface
    private let eventsSubject = CurrentValueSubject<[WorkoutEvent], Never>([])
    private var cancellables: Set<AnyCancellable> = []

    public init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
        setupBindings()
        fetchEvents()
    }

    public func fetchEvents() {
        let request = CDWorkoutEvent.fetchRequest()
        do {
            let events = try coreDataService.context.fetch(request)
            eventsSubject.send(events.compactMap(\.coreModel))
        } catch {
            eventsErrorPublisher.send(.storageError(.readFailed))
        }
    }

    public func deleteEvent(_ event: WorkoutEvent, shouldDeleteAllFutureEvents: Bool) {
        if shouldDeleteAllFutureEvents {
            deleteFutureRecurrences(for: event)
        } else {
            deleteFromDatabase(event)
        }
    }

    private func deleteFromDatabase(_ event: WorkoutEvent) {
        let request = CDWorkoutEvent.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", event.id)

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

    private func deleteFutureRecurrences(for event: WorkoutEvent) {
        guard let recurrenceId = event.recurrenceId else { return }
        let request = CDWorkoutEvent.fetchRequest()
        request.predicate = NSPredicate(format: "recurrenceId == %@", recurrenceId)

        do {
            let recurrences = try coreDataService.context.fetch(request)
            recurrences
                .filter { $0.date! >= event.date }
                .forEach { event in
                    coreDataService.context.delete(event)
                }
            try coreDataService.saveContext()
        } catch {
            eventsErrorPublisher.send(.internalError(.cancelingRecurrenceFailed))
        }
    }

    private func setupBindings() {
        coreDataService.dataUpdatedPublisher
            .sink { [weak self] _ in
                self?.fetchEvents()
            }
            .store(in: &cancellables)
    }
}

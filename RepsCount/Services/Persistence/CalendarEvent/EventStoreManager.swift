//
//  EventKitManager.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/18/25.
//

import EventKit
import Combine
import Core

public protocol EventStoreManagerInterface {
    /// Specifies the authorization status for the app.
    var authorizationStatusPublisher: AnyPublisher<EKAuthorizationStatus, Never> { get }
    var store: EKEventStore { get }

    func setupEventStore() async throws
    func saveWorkoutEvent(_ workoutEvent: WorkoutEvent, calendar: EKCalendar?) async throws
}

public final class EventStoreManager: EventStoreManagerInterface {

    /// Specifies the authorization status for the app.
    public var authorizationStatusPublisher: AnyPublisher<EKAuthorizationStatus, Never> {
        authorizationStatusSubject.eraseToAnyPublisher()
    }

    public var store: EKEventStore {
         dataStore.eventStore
    }

    private let dataStore: EventDataStore
    private let authorizationStatusSubject = CurrentValueSubject<EKAuthorizationStatus, Never>(.notDetermined)

    public init(dataStore: EventDataStore) {
        self.dataStore = dataStore
        authorizationStatusSubject.value = EKEventStore.authorizationStatus(for: .event)
    }

    public func setupEventStore() async throws {
        _ = try await dataStore.verifyAuthorizationStatus()
        authorizationStatusSubject.value = EKEventStore.authorizationStatus(for: .event)
    }

    public func saveWorkoutEvent(_ workoutEvent: WorkoutEvent, calendar: EKCalendar? = nil) async throws {
        try await dataStore.addWorkoutEvent(workoutEvent, calendar: calendar)
    }
}

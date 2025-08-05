//
//  EventKitManager.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/18/25.
//

import EventKit
import Combine

protocol EventStoreManagerInterface {
    /// Specifies the authorization status for the app.
    var authorizationStatusPublisher: AnyPublisher<EKAuthorizationStatus, Never> { get }
    var store: EKEventStore { get }

    func setupEventStore() async throws
    func saveWorkoutEvent(_ workoutEvent: WorkoutEvent, calendar: EKCalendar?) async throws
}

final class EventStoreManager: EventStoreManagerInterface {

    /// Specifies the authorization status for the app.
    var authorizationStatusPublisher: AnyPublisher<EKAuthorizationStatus, Never> {
        authorizationStatusSubject.eraseToAnyPublisher()
    }

    var store: EKEventStore {
         dataStore.eventStore
    }

    private let dataStore: EventDataStore
    private let authorizationStatusSubject = CurrentValueSubject<EKAuthorizationStatus, Never>(.notDetermined)

    init() {
        self.dataStore = ServiceManager.shared.eventDataStore
        authorizationStatusSubject.value = EKEventStore.authorizationStatus(for: .event)
    }

    func setupEventStore() async throws {
        _ = try await dataStore.verifyAuthorizationStatus()
        authorizationStatusSubject.value = EKEventStore.authorizationStatus(for: .event)
    }

    func saveWorkoutEvent(_ workoutEvent: WorkoutEvent, calendar: EKCalendar? = nil) async throws {
        try await dataStore.addWorkoutEvent(workoutEvent, calendar: calendar)
    }
}

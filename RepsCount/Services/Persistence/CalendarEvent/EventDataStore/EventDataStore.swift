import EventKit

actor EventDataStore {
    let eventStore: EKEventStore

    init() {
        self.eventStore = EKEventStore()
    }

    /// Prompts the user for write-only authorization to Calendar.
    func requestWriteOnlyAccess() async throws(CoreError) -> Bool {
        if #available(iOS 17.0, *) {
            do {
                return try await eventStore.requestWriteOnlyAccessToEvents()
            } catch {
                throw CoreError.eventStoreError(.denied)
            }
        } else {
            do {
                // Fall back on earlier versions.
                return try await eventStore.requestAccess(to: .event)
            } catch {
                throw CoreError.eventStoreError(.denied)
            }
        }
    }

    /// Verifies the authorization status for the app.
    func verifyAuthorizationStatus() async throws(CoreError) -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)

        switch status {
        case .notDetermined:
            return try await requestWriteOnlyAccess()
        case .restricted:
            throw CoreError.eventStoreError(.restricted)
        case .denied:
            throw CoreError.eventStoreError(.denied)
        case .fullAccess:
            return true
        case .writeOnly:
            return true
        @unknown default:
            throw CoreError.eventStoreError(.unknown)
        }
    }

    /// Create an event with the specified workout details, then save it with all its occurrences to the user's Calendar.
    func addWorkoutEvent(_ workoutEvent: WorkoutEvent, calendar: EKCalendar? = nil) throws(CoreError) {
        let newEvent = workoutEvent.event(store: eventStore, calendar: calendar)
        do {
            try self.eventStore.save(newEvent, span: .futureEvents)
        } catch {
            throw CoreError.eventStoreError(.unknown)
        }
    }
}

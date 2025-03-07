//
//  CalendarScreenViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/2/25.
//

import SwiftUI
import Combine
import CoreData

final class CalendarScreenViewModel: ObservableObject {
    @AppStorage(UserDefaultsKey.savesLocation.rawValue) var savesLocation: Bool = true
    @Published var events: [CalendarEvent] = []

    private let calendarEventStorage: CalendarEventStorageInterface
    private let exerciseStorage: ExerciseStorageInterface
    private var cancellable: Set<AnyCancellable> = []

    init(
        calendarEventStorage: CalendarEventStorageInterface,
        exerciseStorage: ExerciseStorageInterface
    ) {
        self.calendarEventStorage = calendarEventStorage
        self.exerciseStorage = exerciseStorage
        setupBindings()
    }

    func remove(_ event: CalendarEvent) {
        do {
            try calendarEventStorage.deleteEvent(event)
        } catch {
            print(error)
        }
    }

    func addExercisesToTheList(_ exercises: [ExerciseModel]) {
        exercises.forEach { model in
            exerciseStorage.addExerciseFromExerciseModel(model, savesLocation: savesLocation)
        }
    }

    private func setupBindings() {
        calendarEventStorage.eventsPublisher
            .sink { completion in
                // TODO: error handle
            } receiveValue: { [weak self] events in
                self?.events = events
            }
            .store(in: &cancellable)
    }
}

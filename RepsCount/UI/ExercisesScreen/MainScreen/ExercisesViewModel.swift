//
//  ExercisesViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/27/24.
//

import SwiftUI
import Combine
import CoreData

final class ExercisesViewModel: ObservableObject {
    private let exerciseStorage: ExerciseStorageInterface
    private let locationManager: LocationManagerInterface
    private var cancellable = Set<AnyCancellable>()

    @Published var exercises: [Exercise] = []
    @AppStorage("savesLocation") var savesLocation: Bool = true

    init(
        exerciseStorage: ExerciseStorageInterface,
        locationManager: LocationManagerInterface
    ) {
        self.exerciseStorage = exerciseStorage
        self.locationManager = locationManager
        setupBindings()
        setup()
    }

    func deleteExercise(_ exercise: Exercise) {
        exerciseStorage.deleteExercise(exercise)
    }

    private func setup() {
        if savesLocation {
            locationManager.initiateLocationManager()
        }
    }

    private func setupBindings() {
        exerciseStorage.exercisesPublisher
            .sink { completion in
                // TODO: error handle
            } receiveValue: { [weak self] exercises in
                self?.exercises = exercises
            }
            .store(in: &cancellable)
    }
}

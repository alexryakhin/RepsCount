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
    @AppStorage(UserDefaultsKey.savesLocation.rawValue) var savesLocation: Bool = true

    var sortedUniqueExerciseNames: [String] {
        let nameCounts = Dictionary(grouping: exercises, by: { $0.name ?? "" })
            .mapValues { $0.count }

        return nameCounts.sorted {
            if $0.value == $1.value {
                return $0.key < $1.key // Secondary sorting by name (alphabetical)
            }
            return $0.value > $1.value // Primary sorting by count (descending)
        }
        .compactMap { $0.key }
    }

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

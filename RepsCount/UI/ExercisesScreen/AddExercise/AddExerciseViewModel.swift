//
//  AddExerciseViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/27/24.
//

import SwiftUI
import CoreData
import Combine

final class AddExerciseViewModel: ObservableObject {
    private let exerciseStorage: ExerciseStorageInterface
    private var cancellable = Set<AnyCancellable>()

    @Published var exerciseTypes: [String: [String: [String]]] = [:]

    @Published var text = String()
    @Published var selectedType = String() {
        didSet {
            if let categories = exerciseTypes[selectedType],
               let firstCategory = categories.keys.first {
                selectedCategory = firstCategory
            } else {
                selectedCategory = ""
            }
        }
    }
    @Published var selectedCategory = String() {
        didSet {
            if let exercises = exerciseTypes[selectedType]?[selectedCategory],
               let firstExercise = exercises.first {
                selectedExercise = firstExercise
            } else {
                selectedExercise = ""
            }
        }
    }
    @Published var selectedExercise = String()

    init(exerciseStorage: ExerciseStorageInterface) {
        self.exerciseStorage = exerciseStorage
        setupBindings()
    }

    func addExercise(savesLocation: Bool) {
        guard !selectedType.isEmpty,
              !selectedCategory.isEmpty,
              !selectedExercise.isEmpty else {
            // Handle invalid input (e.g., show an error message to the user)
            return
        }

        exerciseStorage.addExercise(
            category: selectedCategory,
            exerciseName: selectedExercise,
            savesLocation: savesLocation
        )
    }

    private func setupBindings() {
        exerciseStorage.exerciseCategoriesPublisher
            .sink { completion in
                // TODO: error handle
            } receiveValue: { [weak self] types in
                self?.exerciseTypes = types
                if let firstType = types.first {
                    self?.selectedType = firstType.key
                }
            }
            .store(in: &cancellable)
    }
}

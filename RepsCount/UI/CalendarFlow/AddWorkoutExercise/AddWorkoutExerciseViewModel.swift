//
//  AddWorkoutExerciseViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/27/24.
//

import SwiftUI
import CoreData
import Combine

final class AddWorkoutExerciseViewModel: ObservableObject {
    private let exerciseStorage: ExerciseStorageInterface
    private var cancellable = Set<AnyCancellable>()

    @Published var exerciseModels: [ExerciseModel] = []
    @Published var exerciseTypes: [String: [String: [String]]] = [:]

    @Published var text = String()
    @Published var selectedType: String? = nil {
        didSet {
            selectedCategory = nil
        }
    }
    @Published var selectedCategory: String? = nil {
        didSet {
            selectedExercise = nil
        }
    }
    @Published var selectedExercise: String? = nil

    init(exerciseStorage: ExerciseStorageInterface) {
        self.exerciseStorage = exerciseStorage
        setupBindings()
    }

    func findExerciseModel() -> ExerciseModel? {
        exerciseModels.first { model in
            model.type == selectedType
            && model.category == selectedCategory
            && model.name == selectedExercise
        }
    }

    private func setupBindings() {
        exerciseStorage.exerciseCategoriesPublisher
            .sink { completion in
                // TODO: error handle
            } receiveValue: { [weak self] types in
                self?.exerciseTypes = types
            }
            .store(in: &cancellable)

        exerciseStorage.exerciseModelsPublisher
            .sink { completion in
                // TODO: error handle
            } receiveValue: { [weak self] models in
                self?.exerciseModels = models
            }
            .store(in: &cancellable)
    }
}

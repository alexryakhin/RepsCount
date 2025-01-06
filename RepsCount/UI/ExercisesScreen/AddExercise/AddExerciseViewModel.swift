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
    private let coreDataStorage: CoreDataStorageInterface
    private var cancellable = Set<AnyCancellable>()

    @Published var exerciseCategories: [String: [String]] = [:]

    @Published var text = String()
    @Published var selectedCategory = String() {
        willSet {
            if let firstExercise = exerciseCategories[newValue]?.first {
                selectedExercise = firstExercise
            }
        }
    }
    @Published var selectedExercise = String()

    init() {
        coreDataStorage = CoreDataStorage.shared
        setupBindings()
    }

    func addExercise(savesLocation: Bool) {
        coreDataStorage.addExercise(
            category: selectedCategory,
            exerciseName: selectedExercise,
            savesLocation: savesLocation
        )
    }

    private func setupBindings() {
        coreDataStorage.exerciseCategoriesPublisher
            .sink { completion in
                // TODO: error handle
            } receiveValue: { [weak self] categories in
                self?.exerciseCategories = categories
                if let firstCategory = categories.keys.sorted().first {
                    self?.selectedCategory = firstCategory
                }
            }
            .store(in: &cancellable)
    }
}

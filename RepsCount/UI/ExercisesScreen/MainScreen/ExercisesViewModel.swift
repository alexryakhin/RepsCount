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
    private let coreDataStorage: CoreDataStorageInterface
    private var cancellable = Set<AnyCancellable>()

    @Published var exercises: [Exercise] = []
    @AppStorage("savesLocation") var savesLocation: Bool = true

    init() {
        coreDataStorage = CoreDataStorage.shared
        setupBindings()
    }

    func deleteExercise(_ exercise: Exercise) {
        coreDataStorage.deleteExercise(exercise)
    }

    private func setupBindings() {
        coreDataStorage.exercisesPublisher
            .sink { completion in
                // TODO: error handle
            } receiveValue: { [weak self] exercises in
                self?.exercises = exercises
            }
            .store(in: &cancellable)
    }
}

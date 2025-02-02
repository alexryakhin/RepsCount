//
//  EditExercisesViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/12/25.
//

import Foundation
import Combine

final class EditExercisesViewModel: ObservableObject {
    private let exerciseStorage: ExerciseStorageInterface

    init(exerciseStorage: ExerciseStorageInterface) {
        self.exerciseStorage = exerciseStorage
    }
}

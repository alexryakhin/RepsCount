//
//  ExerciseDetailsView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct ExerciseDetailsView: View {
    
    // MARK: - Properties
    
    let exercise: Exercise?

    @StateObject private var viewModel: ExerciseDetailsViewModel
    
    // MARK: - Initialization
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self._viewModel = StateObject(wrappedValue: ExerciseDetailsViewModel(exercise: exercise))
    }
    
    init(exerciseID: String) {
        self.exercise = nil
        self._viewModel = StateObject(
            wrappedValue: ExerciseDetailsViewModel(
                exercise: Exercise(
                    model: .barbellRows,
                    id: exerciseID,
                    timestamp: .now,
                    sets: [],
                    notes: "",
                    location: nil,
                    workoutInstanceId: nil,
                    defaultAmount: .zero,
                    defaultSets: .zero
                )
            )
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        ExerciseDetailsContentView(viewModel: viewModel)
            .navigationTitle(LocalizationKeys.Navigation.exerciseDetails)
            .navigationBarTitleDisplayMode(.large)
    }
}

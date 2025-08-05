//
//  ExerciseDetailsView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct ExerciseDetailsView: View {
    
    // MARK: - Properties
    
    let exercise: Exercise

    @StateObject private var viewModel: ExerciseDetailsViewModel
    
    // MARK: - Initialization
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self._viewModel = StateObject(wrappedValue: ExerciseDetailsViewModel(exercise: exercise))
    }
    
    // MARK: - Body
    
    var body: some View {
        ExerciseDetailsContentView(viewModel: viewModel)
            .navigationTitle(Loc.Navigation.exerciseDetails.localized)
    }
}

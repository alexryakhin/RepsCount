//
//  ExercisesListView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct ExercisesListView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = ExercisesListViewModel()
    @Binding var navigationPath: NavigationPath
    
    // MARK: - Body
    
    var body: some View {
        ExercisesListContentView(viewModel: viewModel)
            .navigationTitle(Loc.Navigation.allExercises.localized)
            .onReceive(viewModel.output) { output in
                handleOutput(output)
            }
    }
    
    // MARK: - Private Methods
    
    private func handleOutput(_ output: ExercisesListViewModel.Output?) {
        guard let output = output else { return }
        switch output {
        case .showExerciseDetails(let exercise):
            navigationPath.append(exercise)
        }
    }
}

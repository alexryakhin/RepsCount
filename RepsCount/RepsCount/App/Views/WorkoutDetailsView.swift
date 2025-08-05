//
//  WorkoutDetailsView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct WorkoutDetailsView: View {
    
    // MARK: - Properties
    
    let workout: WorkoutInstance
    @Binding var navigationPath: NavigationPath
    
    @StateObject private var viewModel: WorkoutDetailsViewModel
    
    // MARK: - Initialization
    
    init(workout: WorkoutInstance, navigationPath: Binding<NavigationPath>) {
        self.workout = workout
        self._navigationPath = navigationPath
        self._viewModel = StateObject(wrappedValue: WorkoutDetailsViewModel(workout: workout))
    }
    
    // MARK: - Body
    
    var body: some View {
        WorkoutDetailsContentView(viewModel: viewModel)
            .navigationTitle(Loc.Navigation.workoutDetails.localized)
            .onReceive(viewModel.output) { output in
                handleOutput(output)
            }
    }
    
    // MARK: - Private Methods
    
    private func handleOutput(_ output: WorkoutDetailsViewModel.Output?) {
        guard let output = output else { return }
        switch output {
        case .showExerciseDetails(let exercise):
            navigationPath.append(exercise)
        case .finish:
            // Handle finish if needed
            break
        }
    }
}

//
//  WorkoutDetailsView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct WorkoutDetailsView: View {
    
    // MARK: - Properties
    
    let workout: WorkoutInstance?
    let workoutID: String?
    
    @StateObject private var viewModel: WorkoutDetailsViewModel
    
    // MARK: - Initialization
    
    init(workout: WorkoutInstance) {
        self.workout = workout
        self.workoutID = nil
        self._viewModel = StateObject(wrappedValue: WorkoutDetailsViewModel(workout: workout))
    }
    
    // MARK: - Body
    
    var body: some View {
        WorkoutDetailsContentView(viewModel: viewModel)
            .navigationTitle(Loc.Navigation.workoutDetails.localized)
    }
}

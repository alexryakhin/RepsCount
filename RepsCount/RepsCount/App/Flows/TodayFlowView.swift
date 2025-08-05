//
//  TodayFlowView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct TodayFlowView: View {
    
    // MARK: - Properties
    
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = TodayMainViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            TodayMainContentView(viewModel: viewModel)
                .onReceive(viewModel.output) { output in
                    handleOutput(output)
                }
        }
    }
    
    // MARK: - Private Methods
    
    private func handleOutput(_ output: TodayMainViewModel.Output) {
        switch output {
        case .showWorkoutDetails(let workout):
            navigationPath.append(workout)
        case .showAllWorkouts:
            navigationPath.append("workouts_list")
        case .showAllExercises:
            navigationPath.append("exercises_list")
        }
    }
}


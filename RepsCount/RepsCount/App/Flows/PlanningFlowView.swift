//
//  PlanningFlowView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct PlanningFlowView: View {
    
    // MARK: - Properties
    
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = PlanningMainViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            PlanningMainContentView(viewModel: viewModel)
                .onReceive(viewModel.output) { output in
                    handleOutput(output)
                }
        }
    }
    
    // MARK: - Private Methods
    
    private func handleOutput(_ output: PlanningMainViewModel.Output) {
        switch output {
        case .createWorkoutTemplate:
            navigationPath.append(
                WorkoutTemplate(
                    id: UUID().uuidString,
                    name: "",
                    notes: nil,
                    templateExercises: [],
                    workoutInstanceIds: [],
                    workoutEventIds: []
                )
            )
        case .editWorkoutTemplate(let template):
            navigationPath.append(template)
        case .showCalendar:
            navigationPath.append("calendar")
        }
    }
}

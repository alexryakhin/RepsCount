//
//  FitnessFlowView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct FitnessFlowView: View {
    
    // MARK: - Properties
    
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = FitnessMainViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            FitnessMainContentView(viewModel: viewModel)
                .onReceive(viewModel.output) { output in
                    handleOutput(output)
                }
        }
    }
    
    // MARK: - Private Methods
    
    private func handleOutput(_ output: FitnessMainViewModel.Output) {
        switch output {
        case .showAnalyticsDashboard:
            navigationPath.append("analytics_dashboard")
        case .showTrainingLoad:
            navigationPath.append("training_load")
        case .showRunDetails(let run):
            navigationPath.append(run)
        }
    }
} 
//
//  WorkoutsListView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct WorkoutsListView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = WorkoutsListViewModel()
    @Binding var navigationPath: NavigationPath
    
    // MARK: - Body
    
    var body: some View {
        WorkoutsListContentView(viewModel: viewModel)
            .navigationTitle(Loc.Navigation.allWorkouts.localized)
            .onReceive(viewModel.output) { output in
                handleOutput(output)
            }
    }
    
    // MARK: - Private Methods
    
    private func handleOutput(_ output: WorkoutsListViewModel.Output?) {
        guard let output = output else { return }
        switch output {
        case .showWorkoutDetails(let workout):
            navigationPath.append(workout)
        }
    }
}

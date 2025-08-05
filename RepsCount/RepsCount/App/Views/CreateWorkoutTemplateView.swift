//
//  CreateWorkoutTemplateView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct CreateWorkoutTemplateView: View {
    
    // MARK: - Properties
    
    let workoutTemplateID: String?
    
    @StateObject private var viewModel: CreateWorkoutTemplateViewViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Initialization
    
    init(workoutTemplateID: String?) {
        self.workoutTemplateID = workoutTemplateID
        self._viewModel = StateObject(wrappedValue: CreateWorkoutTemplateViewViewModel(workoutTemplateID: workoutTemplateID))
    }
    
    // MARK: - Body
    
    var body: some View {
        CreateWorkoutTemplateViewContentView(viewModel: viewModel)
            .navigationTitle(workoutTemplateID == nil ? LocalizationKeys.Planning.createTemplate : LocalizationKeys.Planning.editWorkoutTemplate)
            .navigationBarTitleDisplayMode(.large)
            .onReceive(viewModel.output) { output in
                handleOutput(output)
            }
    }
    
    // MARK: - Private Methods
    
    private func handleOutput(_ output: CreateWorkoutTemplateViewViewModel.Output) {
        switch output {
        case .dismiss:
            dismiss()
        }
    }
}

//
//  ScheduleEventView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct ScheduleEventView: View {
    
    // MARK: - Properties
    
    let configModel: ScheduleEventViewModel.ConfigModel
    @StateObject private var viewModel: ScheduleEventViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Initialization
    
    init(configModel: ScheduleEventViewModel.ConfigModel) {
        self.configModel = configModel
        self._viewModel = StateObject(wrappedValue: ScheduleEventViewModel(configModel: configModel))
    }
    
    // MARK: - Body
    
    var body: some View {
        ScheduleEventContentView(viewModel: viewModel)
            .navigationTitle(Loc.Calendar.scheduleWorkout.localized)
            .onReceive(viewModel.output) { output in
                handleOutput(output)
            }
    }
    
    // MARK: - Private Methods
    
    private func handleOutput(_ output: ScheduleEventViewModel.Output) {
        switch output {
        case .dismiss:
            dismiss()
        case .showCalendarChooser:
            // Handle calendar chooser if needed
            break
        }
    }
} 

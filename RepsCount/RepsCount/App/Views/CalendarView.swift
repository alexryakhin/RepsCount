//
//  CalendarView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct CalendarView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = CalendarViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    var body: some View {
        CalendarContentView(viewModel: viewModel)
            .navigationTitle(Loc.Navigation.calendar.localized)
            .onReceive(viewModel.output) { output in
                handleOutput(output)
            }
    }
    
    // MARK: - Private Methods
    
    private func handleOutput(_ output: CalendarViewModel.Output) {
        switch output {
        case .scheduleWorkout(let configModel):
            // Navigate to schedule event view
            // This would typically push to a new view, but for now we'll dismiss
            dismiss()
        case .presentDeleteEventAlert(let event):
            // Handle delete event alert
            break
        }
    }
}

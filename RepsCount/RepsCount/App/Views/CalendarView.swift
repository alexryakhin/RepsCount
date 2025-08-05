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
    @Binding var navigationPath: NavigationPath
    
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
            navigationPath.append(configModel)
        case .presentDeleteEventAlert(let event):
            // Handle delete event alert
            break
        }
    }
}

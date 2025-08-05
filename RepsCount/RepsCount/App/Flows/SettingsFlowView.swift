//
//  SettingsFlowView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct SettingsFlowView: View {
    
    // MARK: - Properties
    
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = SettingsViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            SettingsContentView(viewModel: viewModel)
                .onReceive(viewModel.output) { output in
                    handleOutput(output)
                }
        }
    }
    
    // MARK: - Private Methods
    
    private func handleOutput(_ output: SettingsViewModel.Output) {
        switch output {
        case .showAboutApp:
            navigationPath.append("about_app")
        }
    }
}

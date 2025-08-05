//
//  AboutAppView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct AboutAppView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = AboutAppViewModel()
    
    // MARK: - Body
    
    var body: some View {
        AboutAppContentView(viewModel: viewModel)
            .navigationTitle(LocalizationKeys.Navigation.aboutApp)
            .navigationBarTitleDisplayMode(.large)
    }
}

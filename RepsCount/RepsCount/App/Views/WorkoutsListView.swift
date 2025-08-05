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
    
    // MARK: - Body
    
    var body: some View {
        WorkoutsListContentView(viewModel: viewModel)
            .navigationTitle(LocalizationKeys.Navigation.allWorkouts)
            .navigationBarTitleDisplayMode(.large)
    }
}

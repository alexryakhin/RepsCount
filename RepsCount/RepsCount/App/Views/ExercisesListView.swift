//
//  ExercisesListView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct ExercisesListView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = ExercisesListViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ExercisesListContentView(viewModel: viewModel)
            .navigationTitle(Loc.Navigation.allExercises.localized)
    }
}

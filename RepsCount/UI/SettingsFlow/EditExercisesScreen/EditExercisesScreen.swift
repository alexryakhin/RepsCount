//
//  EditExercisesScreen.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/12/25.
//

import SwiftUI

struct EditExercisesScreen: View {

    @ObservedObject private var viewModel: EditExercisesViewModel

    init(viewModel: EditExercisesViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text("EditExercisesScreen")
    }
}

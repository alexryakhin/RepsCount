//
//  ExerciseListCellView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/21/25.
//

import SwiftUI
import CoreUserInterface

struct ExerciseListCellView: ConfigurableView {

    struct Model {
        let exercise: String
    }

    var model: Model

    var body: some View {
        HStack(spacing: 8) {
            Text(model.exercise)
                .bold()
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .frame(sideLength: 12)
                .foregroundColor(.secondary)
        }
    }
}

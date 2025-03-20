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
        let categories: String
    }

    var model: Model

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.exercise)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(model.categories)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .frame(sideLength: 12)
                .foregroundColor(.secondary)
        }
    }
}

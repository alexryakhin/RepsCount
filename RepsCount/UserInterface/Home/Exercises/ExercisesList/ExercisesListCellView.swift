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
        let exercise: LocalizedStringKey
        let category: LocalizedStringKey
        let dateFormatted: String
    }

    var model: Model

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(model.exercise)
                    .font(.headline)
                + Text(", ")
                + Text(model.category)

                Text(model.dateFormatted)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .frame(sideLength: 12)
                .foregroundColor(.secondary)
        }
    }
}

//
//  ExerciseListCellView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/21/25.
//

import SwiftUI
import Core
import CoreUserInterface

struct ExerciseListCellView: View {

    var exercise: Exercise

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.model.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(exercise.model.categoriesLocalizedNames)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if exercise.defaultSets != 0 {
                    ProgressView(value: min(Double(exercise.sets.count) / exercise.defaultSets, 1))
                        .progressViewStyle(.linear)
                        .padding(.top, 4)
                }

            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .frame(sideLength: 12)
                .foregroundColor(.secondary)
        }
    }
}

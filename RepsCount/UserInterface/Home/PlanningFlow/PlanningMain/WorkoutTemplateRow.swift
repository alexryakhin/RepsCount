//
//  WorkoutTemplateRow.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/17/25.
//

import SwiftUI
import Core
import CoreUserInterface

struct WorkoutTemplateRow: View {
    let template: WorkoutTemplate

    var body: some View {
        HStack(spacing: 12) {
            MuscleMapView(exercises: template.templateExercises.map(\.exerciseModel))
                .frame(width: 80)

            VStack(alignment: .leading) {
                Text(template.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Targets: \(template.templateExercises.map(\.exerciseModel.categoriesLocalizedNames).removedDuplicates.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
    }
}

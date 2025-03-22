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
            MuscleMapImageView(exercises: template.templateExercises.map(\.exerciseModel), width: 80)
                .frame(width: 80)

            VStack(alignment: .leading, spacing: 4) {
                Text(template.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Targets: \(template.templateExercises.map(\.exerciseModel.categories).reduce([], +).removedDuplicates.map(\.name).joined(separator: ", "))")
                    .font(.caption)
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

//
//  WorkoutTemplateExerciseRow.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/29/25.
//
import SwiftUI
import CoreUserInterface
import Core

struct WorkoutTemplateExerciseRow: View {
    var exercise: WorkoutTemplateExercise
    var onEdit: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.exerciseModel.name)
                    .bold()
                    .foregroundStyle(.primary)
                Text(exercise.exerciseModel.categoriesLocalizedNames)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .trailing, spacing: 4) {
                Text("Sets: \(exercise.defaultSets.formatted())")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                switch exercise.exerciseModel.metricType {
                case .reps:
                    Text("Reps: \(exercise.defaultAmount.formatted())")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                case .time:
                    Text("Time (sec): \(exercise.defaultAmount.formatted())")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                @unknown default:
                    fatalError()
                }
                Button("Edit", action: onEdit)
                    .font(.caption)
            }
        }
    }
}

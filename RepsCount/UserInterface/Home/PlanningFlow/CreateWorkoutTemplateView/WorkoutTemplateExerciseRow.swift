//
//  WorkoutTemplateExerciseRow.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/29/25.
//
import SwiftUI

struct WorkoutTemplateExerciseRow: View {
    var exercise: WorkoutTemplateExercise
    var onEdit: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "dumbbell.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(exercise.exerciseModel.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(exercise.exerciseModel.categoriesLocalizedNames)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .trailing, spacing: 6) {
                HStack(spacing: 8) {
                    Text("Sets: \(exercise.defaultSets.formatted())")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    switch exercise.exerciseModel.metricType {
                    case .reps:
                        Text("Reps: \(exercise.defaultAmount.formatted())")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    case .time:
                        Text("Time: \(exercise.defaultAmount.formatted())s")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    @unknown default:
                        fatalError()
                    }
                }
                
                Button(Loc.Common.edit.localized, action: onEdit)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.tertiarySystemGroupedBackground))
        )
    }
}

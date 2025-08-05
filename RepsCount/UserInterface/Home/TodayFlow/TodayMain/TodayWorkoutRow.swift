//
//  TodayWorkoutRow.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/19/25.
//
import SwiftUI

struct TodayWorkoutRow: View {
    let workout: WorkoutInstance

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(workout.isCompleted ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                MuscleMapImageView(exercises: workout.exercises.map(\.model), width: 50)
                    .frame(width: 50, height: 50)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(workout.defaultName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    if workout.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }

                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Started at: \(workout.date.formatted(date: .omitted, time: .shortened))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text(workout.exercises.map(\.model.categories).reduce([], +).removedDuplicates.map(\.name).joined(separator: ", "))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.tertiarySystemGroupedBackground))
        )
    }
}


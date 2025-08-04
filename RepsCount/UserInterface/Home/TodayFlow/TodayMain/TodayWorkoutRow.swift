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
        HStack(spacing: 12) {
            MuscleMapImageView(exercises: workout.exercises.map(\.model), width: 80)
                .frame(width: 80)

            VStack(alignment: .leading, spacing: 4) {
                Text(workout.defaultName)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text("Started at: \(workout.date.formatted(date: .omitted, time: .shortened))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(workout.exercises.map(\.model.categories).reduce([], +).removedDuplicates.map(\.name).joined(separator: ", "))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                if workout.isCompleted {
                    Text("Completed ✅")
                        .font(.footnote)
                        .foregroundColor(.green)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
    }
}


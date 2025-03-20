//
//  TodayWorkoutRow.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/19/25.
//
import Core
import CoreUserInterface
import SwiftUI

struct TodayWorkoutRow: View {
    let workout: WorkoutInstance

    var body: some View {
        HStack(spacing: 12) {
            MuscleMapView(exercises: workout.exercises.map(\.model))
                .frame(width: 80)

            VStack(alignment: .leading) {
                Text(workout.defaultName)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text("Started at: \(workout.date, formatter: DateFormatter.shortTime)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(workout.exercises.map(\.model.categoriesLocalizedNames).removedDuplicates.joined(separator: ", "))
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


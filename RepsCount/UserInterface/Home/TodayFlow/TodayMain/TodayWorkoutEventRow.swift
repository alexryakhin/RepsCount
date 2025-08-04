//
//  TodayWorkoutEventRow.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/19/25.
//
import SwiftUI

struct TodayWorkoutEventRow: View {
    let event: WorkoutEvent

    var body: some View {
        HStack(spacing: 12) {
            MuscleMapImageView(exercises: event.template.templateExercises.map(\.exerciseModel), width: 80)
                .frame(width: 80)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.template.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("Planned at: \(event.date.formatted(date: .omitted, time: .shortened))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
    }
}

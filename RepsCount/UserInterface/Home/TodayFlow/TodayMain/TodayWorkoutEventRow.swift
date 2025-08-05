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
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                MuscleMapImageView(exercises: event.template.templateExercises.map(\.exerciseModel), width: 50)
                    .frame(width: 50, height: 50)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(event.template.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Planned at: \(event.date.formatted(date: .omitted, time: .shortened))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

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

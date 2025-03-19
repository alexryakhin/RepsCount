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
        VStack(alignment: .leading) {
            Text(workout.workoutTemplate.name)
                .font(.headline)
            Text("Planned at: \(workout.date, formatter: DateFormatter.shortTime)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if workout.isCompleted {
                Text("Completed ✅")
                    .font(.footnote)
                    .foregroundColor(.green)
            }
        }
    }
}


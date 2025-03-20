//
//  TodayWorkoutEventRow.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/19/25.
//
import Core
import CoreUserInterface
import SwiftUI

struct TodayWorkoutEventRow: View {
    let event: WorkoutEvent

    var body: some View {
        HStack(spacing: 12) {
            MuscleMapView(exercises: event.template.templateExercises.map(\.exerciseModel))
                .frame(width: 80)

            VStack(alignment: .leading) {
                Text(event.template.workoutTitle)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("Planned at: \(event.date, formatter: DateFormatter.shortTime)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
    }
}

//
//  ExerciseSetRow.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/26/25.
//

import Foundation
import SwiftUI

struct ExerciseSetRow: View {
    var exerciseSet: ExerciseSet
    var index: Int
    var weight: String
    var maxReps: Double?
    var metricType: ExerciseMetricType

    @State private var rowSize: CGSize = .zero

    var body: some View {
        HStack {
            Group {
                switch metricType {
                case .reps:
                    exerciseSet.setRepsText(index: index, weight: exerciseSet.weight > 0 ? weight : nil)
                        .fontWeight(.semibold)
                case .time:
                    exerciseSet.setTimeText(index: index, weight: exerciseSet.weight > 0 ? weight : nil)
                        .fontWeight(.semibold)
                @unknown default:
                    fatalError()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let maxReps {
                Gauge(value: min(exerciseSet.amount / maxReps, 1)) {}
                    .gaugeStyle(.accessoryLinear)
                    .tint(Gradient(colors: [.green, .blue]))
            }

            Text(exerciseSet.timestamp.formatted(date: .omitted, time: .standard))
                .font(.system(.subheadline, design: .monospaced))
                .foregroundStyle(.secondary)
        }
    }
}

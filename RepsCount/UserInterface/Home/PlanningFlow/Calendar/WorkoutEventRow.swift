//
//  WorkoutEventRow.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/21/25.
//

import SwiftUI
import Core

struct WorkoutEventRow: View {
    let event: WorkoutEvent

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.template.name)
                .font(.headline)
            Text("Planned at: \(event.date, formatter: DateFormatter.shortTime)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

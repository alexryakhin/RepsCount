//
//  WorkoutEventRow.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/21/25.
//

import SwiftUI

struct WorkoutEventRow: View {
    let event: WorkoutEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.template.name)
                .font(.headline)
            Text("Planned at: \(event.date.formatted(date: .omitted, time: .shortened))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//
//  CalendarScreen.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/6/25.
//

import SwiftUI
import CoreData
import Flow

struct CalendarScreen: View {
    private let resolver = DIContainer.shared.resolver

    @State private var selectedDate: Date = .now
    @ObservedObject private var viewModel: CalendarScreenViewModel

    private var groupedEvents: [Date: [CalendarEvent]] {
        Dictionary(grouping: viewModel.events, by: { event in
            // Use only the day component for grouping
            (event.date ?? .now).trimmed()
        })
    }

    init(viewModel: CalendarScreenViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                }

                Section {
                    if let events = groupedEvents[selectedDate.trimmed()] {
                        ForEach(events) { event in
                            workoutCard(for: event)
                        }
                    } else {
                        Text("No workouts scheduled for this day")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        NavigationLink {
                            resolver.resolve(PlanWorkoutScreen.self)!
                        } label: {
                            Text("Plan a workout")
                        }
                    }
                }
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Add event") {
                        resolver.resolve(PlanWorkoutScreen.self)!
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    @ViewBuilder
    private func workoutCard(for event: CalendarEvent) -> some View {
        if let title = event.title {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Text(title)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Menu {
                        if let exercises = event.exercises as? Set<ExerciseModel>, exercises.isEmpty == false {
                            Button {
                                viewModel.addExercisesToTheList(exercises.sorted())
                                HapticManager.shared.triggerNotification(type: .success)
                            } label: {
                                Label(LocalizedStringKey("Add exercises to the list"), systemImage: "note.text.badge.plus")
                            }
                        }
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.remove(event)
                            }
                            HapticManager.shared.triggerNotification(type: .success)
                        } label: {
                            Label(LocalizedStringKey("Remove workout"), systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.headline)
                    }
                    .foregroundStyle(.secondary)
                }
                .padding(.top, 8)

                if let exercises = event.exercises as? Set<ExerciseModel> {
                    let names = exercises.compactMap { exercise in
                        return exercise.name
                    }.sorted()
                    Divider()
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Exercises:")
                            .font(.callout)
                        HFlow {
                            ForEach(names, id: \.self) { name in
                                Text(name)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(.quinary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
                if let notes = event.notes {
                    Divider()
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Notes:")
                            .font(.callout)
                        Text(notes)
                            .font(.caption)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

extension View {
    @ViewBuilder func active(if condition: Bool) -> some View { if condition { self } }
}

#Preview {
    DIContainer.shared.resolver.resolve(CalendarScreen.self)!
}

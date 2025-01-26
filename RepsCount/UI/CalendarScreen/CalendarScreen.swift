//
//  CalendarScreen.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/6/25.
//

import SwiftUI
import MijickCalendarView
import Combine
import CoreData
import Flow

final class CalendarScreenViewModel: ObservableObject {
    @AppStorage("savesLocation") var savesLocation: Bool = true
    @Published var events: [CalendarEvent] = []

    private let calendarEventStorage: CalendarEventStorageInterface
    private let exerciseStorage: ExerciseStorageInterface
    private var cancellable: Set<AnyCancellable> = []

    init(
        calendarEventStorage: CalendarEventStorageInterface,
        exerciseStorage: ExerciseStorageInterface
    ) {
        self.calendarEventStorage = calendarEventStorage
        self.exerciseStorage = exerciseStorage
        setupBindings()
    }

    func remove(_ event: CalendarEvent) {
        do {
            try calendarEventStorage.deleteEvent(event)
        } catch {
            print(error)
        }
    }

    func addExercisesToTheList(_ exercises: [ExerciseModel]) {
        exercises.forEach { model in
            exerciseStorage.addExerciseFromExerciseModel(model, savesLocation: savesLocation)
        }
    }

    private func setupBindings() {
        calendarEventStorage.eventsPublisher
            .sink { completion in
                // TODO: error handle
            } receiveValue: { [weak self] events in
                self?.events = events
            }
            .store(in: &cancellable)
    }
}

struct CalendarScreen: View {
    private let resolver = DIContainer.shared.resolver

    @State private var selectedDate: Date? = .now
    @State private var selectedMonth: Date = .now
    @State private var selectedRange: MDateRange? = .init()

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
            ScrollView {
                VStack {
                    MCalendarView(
                        selectedDate: $selectedDate,
                        selectedRange: $selectedRange
                    ) { calendar in
                        calendar
                            .firstWeekday(.monday)
                            .dayView(Price.init)
                            .startMonth(selectedMonth)
                            .endMonth(selectedMonth)
                            .monthLabel(MyMonthLabel.init)
                    }
                    .scrollDisabled(true)
                    .fixedSize(horizontal: false, vertical: true)

                    if let selectedDate, let events = groupedEvents[selectedDate.trimmed()] {
                        ForEach(events) { event in
                            workoutCard(for: event)
                        }
                    } else {
                        VStack(spacing: 12) {
                            Text("No workouts scheduled for this day")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            NavigationLink("Plan a workout") {
                                resolver.resolve(PlanWorkoutScreen.self)!
                            }
                            .buttonStyle(.bordered)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .clippedWithBackground()
                    }
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Add event") {
                        resolver.resolve(PlanWorkoutScreen.self)!
                    }
                    .buttonStyle(.bordered)
                }
            }
            .background {
                Color.background.ignoresSafeArea()
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
                            .font(.title)
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
            .clippedWithBackground()
        }
    }
}

struct Price: DayView {
    let date: Date
    let isCurrentMonth: Bool
    let selectedDate: Binding<Date?>?
    let selectedRange: Binding<MDateRange?>?

    var isSelected: Bool {
        date.trimmed() == selectedDate?.wrappedValue?.trimmed()
    }

    func createContent() -> AnyView {
        VStack(spacing: 4) {
            Text(getStringFromDay(format: "d"))
                .font(.headline)
                .foregroundStyle(.primary)

            dotsGridView
        }
        .opacity(isPast() ? 0.5 : 1)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.surface)
        .overlay {
            (isSelected ? Color.accentColor : .clear)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(style: .init(lineWidth: 4))
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(2)
        .erased()
    }

    func onSelection() {
        if !isPast() {
            selectedDate?.wrappedValue = date
        }
    }

    private var dotsGridView: some View {
        LazyHGrid(rows: Array(repeating: GridItem(.flexible(minimum: 4, maximum: 4)), count: 2), spacing: 4) {
            ForEach(0..<Int.random(in: 1...8)) { _ in
                Circle()
                    .fill(Color.red)
                    .frame(width: 5, height: 5)
            }
        }
        .padding(.horizontal, 8)
    }
}

struct MyMonthLabel: MonthLabel {
    var month: Date

    func createContent() -> AnyView {
        Text(month.formatted(
            Date.FormatStyle()
                .year(.defaultDigits)
                .month(.wide)
        ))
        .font(.system(.title, design: .default, weight: .bold))
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .erased()
    }
}

extension View {
    @ViewBuilder func active(if condition: Bool) -> some View { if condition { self } }
}

#Preview {
    DIContainer.shared.resolver.resolve(CalendarScreen.self)!
}

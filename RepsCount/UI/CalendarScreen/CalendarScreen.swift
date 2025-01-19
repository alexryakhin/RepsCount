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
import SwipeActions

final class CalendarScreenViewModel: ObservableObject {

    @Published var events: [CalendarEvent] = []

    private let calendarEventStorage: CalendarEventStorageInterface
    private var cancellable: Set<AnyCancellable> = []

    init(calendarEventStorage: CalendarEventStorageInterface) {
        self.calendarEventStorage = calendarEventStorage
        setupBindings()
    }

    func remove(_ event: CalendarEvent) {
        do {
            try calendarEventStorage.deleteEvent(event)
        } catch {
            print(error)
        }
    }

    func setupBindings() {
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
                    .padding(.horizontal, 16)

                    if let selectedDate, let events = groupedEvents[selectedDate.trimmed()] {
                        ForEach(events) { event in
                            workoutCard(for: event)
                        }
                    } else {
                        VStack(spacing: 12) {
                            Text("No workout scheduled for this day")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            NavigationLink("Plan a workout") {
                                resolver.resolve(PlanWorkoutScreen.self)!
                            }
                            .buttonStyle(.bordered)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .background(Color.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 16)
                    }
                }
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
            SwipeView {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.title)
                            .bold()
                        if let exercises = event.exercises as? Set<ExerciseModel> {
                            let names = exercises.compactMap { exercise in
                                return exercise.name
                            }.sorted()
                            Text(names.joined(separator: ", "))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } trailingActions: { _ in
                SwipeAction {
                    withAnimation {
                        viewModel.remove(event)
                    }
                } label: { flag in
                    Image(systemName: "trash")
                        .foregroundStyle(.white)
                } background: { flag in
                    Color.red
                }
            }
            .swipeActionCornerRadius(16)
            .padding(.horizontal, 16)
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

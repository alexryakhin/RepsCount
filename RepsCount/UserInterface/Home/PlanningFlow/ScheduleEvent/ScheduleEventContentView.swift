import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core
import Flow

public struct ScheduleEventContentView: PageView {

    public typealias ViewModel = ScheduleEventViewModel

    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: ScheduleEventViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        List {
            Section {
                DatePicker("Start date", selection: $viewModel.selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)

                Picker("Duration", selection: $viewModel.duration) {
                    ForEach(WorkoutEventDuration.allCases) { item in
                        Text(item.stringValue)
                            .tag(item)
                    }
                }
                .pickerStyle(.menu)
            } header: {
                Text("Select date")
            }

            if let selectedTemplate = viewModel.selectedTemplate {
                Section {
                    Picker("Workout", selection: .init(
                        get: { selectedTemplate },
                        set: { viewModel.handle(.selectTemplate($0)) }
                    )) {
                        ForEach(viewModel.workoutTemplates) { template in
                            Text(template.name)
                                .tag(template)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Select template")
                }
            }

            Section {
                Toggle("Repeat Workout", isOn: $viewModel.isRecurring)

                if viewModel.isRecurring {
                    Picker("Repeat Frequency", selection: $viewModel.repeats) {
                        ForEach(WorkoutEventRecurrence.allCases, id: \.self) { recurrence in
                            Text(recurrence.rawValue == 0 ? "Daily" : recurrence.rawValue == 1 ? "Weekly" : "Monthly")
                                .tag(recurrence)
                        }
                    }
                    .pickerStyle(.menu)

                    if viewModel.repeats == .weekly {
                        HFlow {
                            ForEach(WorkoutEventDay.allCases) { day in
                                capsuleView(for: day)
                            }
                        }
                    }

                    Stepper(value: $viewModel.interval, in: 1...30) {
                        Text("Interval: \(viewModel.interval.formatted())")
                    }

                    Stepper(value: $viewModel.occurrenceCount, in: 1...100) {
                        Text("Occurrences: \(viewModel.occurrenceCount.formatted())")
                    }
                }
            } header: {
                Text("Recurrence")
            }

            // If user switches the toggle, ask for permission
            Section {
                Toggle("Add to system calendar", isOn: $viewModel.addToCalendar)
                if viewModel.addToCalendar {
                    Button {
                        viewModel.handle(.showCalendarChooser)
                    } label: {
                        if let calendar = viewModel.calendar {
                            HStack {
                                Text("Selected calendar")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(.primary)
                                Text(calendar.title)
                            }
                        } else {
                            Text("Select calendar")
                        }
                    }
                    .disabled(!viewModel.isWriteOnlyOrFullAccessAuthorized)
                }
            } header: {
                Text("Calendar on device")
            }
            .animation(.default, value: viewModel.addToCalendar)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                viewModel.handle(.saveEvent)
            } label: {
                Text("Schedule Workout")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .cornerRadius(12)
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .gradientStyle(.bottomButton)
        }
    }

    @ViewBuilder
    private func capsuleView(for day: WorkoutEventDay) -> some View {
        if let index = viewModel.days.firstIndex(of: day) {
            Button {
                viewModel.days.remove(at: index)
                HapticManager.shared.triggerSelection()
            } label: {
                Text(day.name)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(Capsule())
        } else {
            Button {
                viewModel.days.append(day)
                HapticManager.shared.triggerSelection()
            } label: {
                Text(day.name)
            }
            .buttonStyle(.bordered)
            .clipShape(Capsule())
        }
    }
}

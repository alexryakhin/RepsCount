import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core

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
                    Picker("Recurrence Rule", selection: $viewModel.selectedRecurrenceRule) {
                        ForEach(viewModel.recurrenceRules, id: \.self) { rule in
                            Text(rule)
                                .tag(rule)
                        }
                    }
                    .pickerStyle(.menu)
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
                Text(viewModel.isEditing ? "Save Changes" : "Schedule Workout")
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
}

//
//  PlanWorkoutScreen.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/19/25.
//

import SwiftUI
import Foundation
import CoreData

final class PlanWorkoutScreenViewModel: ObservableObject {

    @Published var eventNameText: String = ""
    @Published var eventNameError: String?

    @Published var notesText: String = ""
    @Published var dateSelection: Date?
    @Published var selectedExerciseModels: Set<ExerciseModel> = []

    private let calendarEventStorage: CalendarEventStorageInterface

    init(calendarEventStorage: CalendarEventStorageInterface) {
        self.calendarEventStorage = calendarEventStorage
    }

    func saveEvent() {
        guard eventNameText.isEmpty == false else {
            eventNameError = "Name is required"
            return
        }
    }
}

struct PlanWorkoutScreen: View {
    private let resolver = DIContainer.shared.resolver
    @Environment(\.dismiss) var dismiss
    @State private var showCancelAlert = false
    @State private var isExerciseSelectionPresented: Bool = false
    @ObservedObject var viewModel: PlanWorkoutScreenViewModel

    init(viewModel: PlanWorkoutScreenViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                InputView(
                    text: $viewModel.eventNameText,
                    error: $viewModel.eventNameError,
                    header: "Workout name",
                    placeholder: "Enter name"
                )
                InputView(
                    text: $viewModel.notesText,
                    header: "Notes",
                    placeholder: "Enter notes",
                    caption: "Not required"
                )
                DateInputView(
                    date: $viewModel.dateSelection,
                    header: "Select a date"
                )
                VStack(alignment: .leading, spacing: 8) {
                    Text("Exercises")
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                    if viewModel.selectedExerciseModels.isEmpty {
                        Text("No exercises added yet.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        ListWithDivider(viewModel.selectedExerciseModels.sorted(by: {
                            $0.name ?? "" < $1.name ?? ""
                        })) { model in
                            VStack(alignment: .leading, spacing: 4) {
                                if let type = model.type,
                                    let category = model.category,
                                    let name = model.name {
                                    Text(name)
                                        .font(.headline)
                                    Text([type, category].joined(separator: ", "))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                        }
                        .background(Color.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

//                        VStack {
//                            ForEach(viewModel.selectedExerciseModels.sorted(by: {
//                                $0.name ?? "" < $1.name ?? ""
//                            })) { model in
//                                VStack {
//                                    Text(model.name!)
//                                    Text(model.category!)
//                                }
//                            }
//                        }
                    }
                    Button("Add exercises") {
                        isExerciseSelectionPresented = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .navigationTitle("Plan a workout")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .cancel) {
                    showCancelAlert.toggle()
                }
                .buttonStyle(.bordered)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    viewModel.saveEvent()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .alert(isPresented: $showCancelAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("You will lose all data entered."),
                primaryButton: .destructive(Text("Yes")) {
                    dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .background {
            Color.background.ignoresSafeArea()
        }
        .sheet(isPresented: $isExerciseSelectionPresented) {
            addExerciseView
        }
    }

    @ViewBuilder
    private var addExerciseView: some View {
        let config = AddWorkoutExerciseView.Config(
            isPresented: $isExerciseSelectionPresented,
            onSelectExerciseModel: { model in
                viewModel.selectedExerciseModels.insert(model)
                isExerciseSelectionPresented = false
            },
            onGoToAddExerciseModel: {
                // TODO: add exercise
                isExerciseSelectionPresented = false
        })
        resolver.resolve(AddWorkoutExerciseView.self, argument: config)!
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
    }
}

#Preview {
    NavigationView {
        DIContainer.shared.resolver.resolve(PlanWorkoutScreen.self)!
    }
}

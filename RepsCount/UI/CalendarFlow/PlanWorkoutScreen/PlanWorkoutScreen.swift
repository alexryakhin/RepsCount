//
//  PlanWorkoutScreen.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/19/25.
//

import SwiftUI
import Foundation
import CoreData
import Flow

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
        List {
//            VStack(spacing: 16) {
            ListInputView(
                text: $viewModel.eventNameText,
                error: $viewModel.eventNameError,
                header: "Workout name",
                placeholder: "Enter name"
            )
            ListInputView(
                text: $viewModel.notesText,
                header: "Notes",
                placeholder: "Enter notes",
                caption: "Not required"
            )
            ListDateInputView(
                date: $viewModel.dateSelection,
                error: $viewModel.dateSelectionError,
                header: "Select a date"
            )
            Section {
                NavigationLink {
                    RecurrenceRulePickerView(existingRule: viewModel.recurrenceRule) { newRule in
                        viewModel.recurrenceRule = newRule

                        if let data = try? JSONEncoder().encode(newRule) {
                            print(data.prettyPrintedJSONString)
                        }
                    }
                } label: {
                    Text("Set Recurrence Rule")
                }
            } header: {
                Text("Recurrence Rule")
            } footer: {
                if let rule = viewModel.recurrenceRule {
                    Text(recurrenceRuleDescription(rule))
                }
            }
            Section {
                if viewModel.selectedExerciseModels.isEmpty {
                    VStack {
                        Text("No exercises added yet.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Button("Add exercise") {
                            isExerciseSelectionPresented = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                } else {
                    HFlow {
                        ForEach(viewModel.selectedExerciseModels.sorted(by: {
                            $0.name ?? "" < $1.name ?? ""
                        })) { model in
                            selectedExerciseCell(model)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                    .animation(.bouncy, value: viewModel.selectedExerciseModels)

                    Button("Add more exercises") {
                        isExerciseSelectionPresented = true
                    }
                }
            } header: {
                Text("Exercises")
            } footer: {
                if let error = viewModel.selectedExerciseModelsError {
                    Text(error)
                        .foregroundStyle(.red.opacity(0.8))
                }
            }
            .listRowBackground(
                viewModel.selectedExerciseModelsError != nil ? Color.red.opacity(0.4) : Color.surface
            )
            .onChange(of: viewModel.selectedExerciseModels) {
                if viewModel.selectedExerciseModelsError != nil {
                    viewModel.selectedExerciseModelsError = nil
                }
            }
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
        .sheet(isPresented: $isExerciseSelectionPresented) {
            addExerciseView
        }
        .onChange(of: viewModel.savedSuccessfully) { isSaved in
            if let isSaved {
                if isSaved {
                    dismiss()
                } else {
                    // TODO: show error snack or something
                }
            }
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
    }

    @ViewBuilder
    private func selectedExerciseCell(_ model: ExerciseModel) -> some View {
        if let name = model.name {
            HStack(spacing: 8) {
                Text(LocalizedStringKey(name))
                    .font(.callout)
                    .foregroundStyle(.primary)
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        viewModel.selectedExerciseModels.remove(model)
                    }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.quinary)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    NavigationView {
        DIContainer.shared.resolver.resolve(PlanWorkoutScreen.self)!
    }
}

extension Data {
    var prettyPrintedJSONString: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyJSON = String(data: data, encoding: .utf8)
        else { return nil }
        return prettyJSON
    }
}

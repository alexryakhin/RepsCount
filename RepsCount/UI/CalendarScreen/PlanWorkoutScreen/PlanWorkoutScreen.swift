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

final class PlanWorkoutScreenViewModel: ObservableObject {

    @Published var savedSuccessfully: Bool?

    @Published var eventNameText: String = ""
    @Published var eventNameError: String?

    @Published var notesText: String = ""

    @Published var dateSelection: Date?
    @Published var dateSelectionError: String?

    @Published var selectedExerciseModels: Set<ExerciseModel> = []
    @Published var selectedExerciseModelsError: String?

    private let calendarEventStorage: CalendarEventStorageInterface

    init(calendarEventStorage: CalendarEventStorageInterface) {
        self.calendarEventStorage = calendarEventStorage
    }

    func saveEvent() {
        guard eventNameText.isEmpty == false else {
            eventNameError = "Name is required"
            return
        }
        guard let dateSelection else {
            dateSelectionError = "Date is required"
            return
        }
        guard selectedExerciseModels.isEmpty == false else {
            selectedExerciseModelsError = "At least one exercise is required"
            return
        }
        do {
            try calendarEventStorage.addEvent(
                title: eventNameText,
                date: dateSelection,
                notes: notesText,
                exercises: selectedExerciseModels
            )
            savedSuccessfully = true
        } catch {
            savedSuccessfully = false
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
                    error: $viewModel.dateSelectionError,
                    header: "Select a date"
                )
                VStack(alignment: .leading, spacing: 8) {
                    Text("Exercises")
                        .font(.subheadline)
                        .padding(.horizontal, 16)
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
                        .background(Color.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            if viewModel.selectedExerciseModelsError != nil {
                                Color.red.clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(style: .init(lineWidth: 2))
                                )
                                .allowsHitTesting(false)
                            }
                        }
                        if let error = viewModel.selectedExerciseModelsError {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.horizontal, 16)
                        }
                    } else {
                        HFlow {
                            ForEach(viewModel.selectedExerciseModels.sorted(by: {
                                $0.name ?? "" < $1.name ?? ""
                            })) { model in
                                selectedExerciseCell(model)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clippedWithBackground()

                        Button("Add more exercises") {
                            isExerciseSelectionPresented = true
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(.bouncy, value: viewModel.selectedExerciseModels)
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
                Button {
                    viewModel.selectedExerciseModels.remove(model)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.quaternary)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    NavigationView {
        DIContainer.shared.resolver.resolve(PlanWorkoutScreen.self)!
    }
}

//
//  AddExerciseView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/21/25.
//

import Core
import CoreUserInterface
import SwiftUI
import Flow

struct AddExerciseView: View {

    var selectedExercises: [ExerciseModel]
    var exerciseSelected: (WorkoutTemplateExercise) -> Void

    @State private var defaultSetsInput: String = ""
    @State private var defaultRepsInput: String = ""
    @State private var exerciseModelToAdd: ExerciseModel?
    @State private var selectedEquipment: Set<ExerciseEquipment> = Set(ExerciseEquipment.allCases)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(ExerciseCategory.allCases, id: \.self) { category in
                        exerciseCategorySectionView(for: category)
                    }
                }
                .padding(vertical: 12, horizontal: 16)
            }
            .background(Color.background)
            .navigationTitle("Add exercise")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ExerciseEquipmentFilterView(selectedEquipment: $selectedEquipment)
                }
            }
        }
        .alert("Defaults", isPresented: .constant(exerciseModelToAdd != nil), presenting: exerciseModelToAdd) { model in
            TextField("Default sets", text: $defaultSetsInput)
                .keyboardType(.numberPad)
            TextField("Default reps", text: $defaultRepsInput)
                .keyboardType(.numberPad)
            Button("Cancel", role: .cancel) {
                defaultSetsInput = ""
                defaultRepsInput = ""
                exerciseModelToAdd = nil
            }
            Button("Add") {
                if let exerciseModelToAdd {
                    exerciseSelected(.init(
                        id: UUID().uuidString,
                        exerciseModel: exerciseModelToAdd,
                        defaultSets: Int(defaultSetsInput) ?? 0,
                        defaultReps: Int(defaultRepsInput) ?? 0,
                        sortingOrder: selectedExercises.count
                    ))
                }
            }
        }
    }

    private func exerciseCategorySectionView(for category: ExerciseCategory) -> some View {
        CustomSectionView(header: LocalizedStringKey(category.name)) {
            let filteredExercises = category.exercises.filter {
                selectedEquipment.contains($0.equipment)
            }
            if filteredExercises.isNotEmpty {
                HFlow {
                    ForEach(filteredExercises, id: \.rawValue) { model in
                        capsuleView(for: model)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .clippedWithPaddingAndBackground(.surface)
            } else {
                Text("No exercises available for this category")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clippedWithPaddingAndBackground(.surface)
            }
        }
    }

    @ViewBuilder
    private func capsuleView(for item: ExerciseModel) -> some View {
        if selectedExercises.contains(item) {
            Button {
                // do nothing
            } label: {
                Text(item.name)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(Capsule())
        } else {
            Button {
                exerciseModelToAdd = item
                HapticManager.shared.triggerSelection()
            } label: {
                Text(item.name)
            }
            .buttonStyle(.bordered)
            .clipShape(Capsule())
        }
    }

}

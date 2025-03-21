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

    @AppStorage(UDKeys.selectedEquipment) private var selectedEquipment: Data = ExerciseEquipment.allCasesData

    private var selectedEquipmentSet: Set<ExerciseEquipment> {
        try! JSONDecoder().decode(Set<ExerciseEquipment>.self, from: selectedEquipment)
    }

    @State private var defaultSetsInput: String = ""
    @State private var defaultRepsInput: String = ""
    @State private var exerciseModelToAdd: ExerciseModel?
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(ExerciseCategory.allCases, id: \.self) { category in
                    exerciseCategorySectionView(for: category)
                }
            }
            .navigationTitle("Add exercise")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ExerciseEquipmentFilterView(selectedEquipment: Binding(get: {
                        selectedEquipmentSet
                    }, set: {
                        selectedEquipment = try! JSONEncoder().encode($0)
                    }))
                }
            }
            .searchable(text: $searchText)
            .overlay {
                if searchText.isNotEmpty {
                    List(ExerciseModel.allCases.filter {
                        selectedEquipmentSet.contains($0.equipment)
                    }.filter {
                        $0.name.localizedStandardContains(searchText)
                    }) { exercise in
                        exerciseCellView(for: exercise)
                    }
                }
            }
        }
        .alert("Defaults", isPresented: .constant(exerciseModelToAdd != nil), presenting: exerciseModelToAdd) { model in
            TextField("Default sets (optional)", text: $defaultSetsInput)
                .keyboardType(.numberPad)
            TextField("Default reps (optional)", text: $defaultRepsInput)
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
                        defaultSets: Double(defaultSetsInput) ?? 0,
                        defaultReps: Double(defaultRepsInput) ?? 0,
                        timestamp: .now
                    ))
                }
            }
        }
    }

    @ViewBuilder
    private func exerciseCategorySectionView(for category: ExerciseCategory) -> some View {
        Section {
            let filteredExercises = category.exercises.filter {
                selectedEquipmentSet.contains($0.equipment)
            }
            if filteredExercises.isNotEmpty {
                ForEach(filteredExercises) { model in
                    exerciseCellView(for: model)
                }
            } else {
                Text("No exercises available for this category")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        } header: {
            Text(category.name)
        }
    }

    @ViewBuilder
    private func exerciseCellView(for exercise: ExerciseModel) -> some View {
        HStack(spacing: 12) {
            MuscleMapImageView(exercise: exercise, width: 60)
                .frame(width: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                HFlow {
                    ForEach(exercise.primaryMuscleGroups) { muscleGroup in
                        Text(muscleGroup.commonNameLocalized)
                            .font(.caption)
                            .padding(vertical: 4, horizontal: 8)
                            .background(Color.secondarySystemFill)
                            .clipShape(Capsule())
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                if !selectedExercises.contains(exercise) {
                    exerciseModelToAdd = exercise
                    HapticManager.shared.triggerSelection()
                }
            } label: {
                Image(systemName: selectedExercises.contains(exercise)
                      ? "checkmark.square.fill"
                      : "square"
                )
                .frame(sideLength: 20)
            }
        }
    }
}

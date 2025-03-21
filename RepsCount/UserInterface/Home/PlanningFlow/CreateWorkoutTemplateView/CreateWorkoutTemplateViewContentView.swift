import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core
import Flow

public struct CreateWorkoutTemplateViewContentView: PageView {

    public typealias ViewModel = CreateWorkoutTemplateViewViewModel

    @ObservedObject public var viewModel: ViewModel
    @FocusState private var isNameFocused: Bool
    @FocusState private var isNotesFocused: Bool
    @State private var isMuscleMapVisible: Bool = true

    public init(viewModel: CreateWorkoutTemplateViewViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                muscleMapSectionView
                workoutNameSectionView
                notesSectionView
                selectedExerciseSectionView
                Text("Select exercises")
                    .font(.title2)
                    .bold()
                    .listRowBackground(Color.clear)

                ForEach(ExerciseCategory.allCases, id: \.self) { category in
                    exerciseCategorySectionView(for: category)
                }
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .background(Color.background)
        .overlay(alignment: .topTrailing) {
            if !isMuscleMapVisible {
                floatingMuscleMapView
            }
        }
        .animation(.default, value: isMuscleMapVisible)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ExerciseEquipmentFilterView(selectedEquipment: $viewModel.selectedEquipment)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                viewModel.handle(.saveTemplate)
            } label: {
                Text(viewModel.isEditing ? "Save Changes" : "Create Template")
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
        .alert("Defaults", isPresented: .constant(viewModel.exerciseModelToAdd != nil), presenting: viewModel.exerciseModelToAdd) { model in
            TextField("Default sets", text: $viewModel.defaultSetsInput)
                .keyboardType(.numberPad)
            TextField("Default reps", text: $viewModel.defaultRepsInput)
                .keyboardType(.numberPad)
            Button("Cancel", role: .cancel) {
                viewModel.defaultSetsInput = ""
                viewModel.defaultRepsInput = ""
                viewModel.exerciseModelToAdd = nil
            }
            Button("Add") {
                viewModel.handle(.appendNewExercise(model))
            }
        }
        .alert("Edit defaults", isPresented: .constant(viewModel.editingDefaultsExercise != nil), presenting: viewModel.editingDefaultsExercise) { exercise in
            TextField("Default sets", text: $viewModel.defaultSetsInput)
                .keyboardType(.numberPad)
            TextField("Default reps", text: $viewModel.defaultRepsInput)
                .keyboardType(.numberPad)
            Button("Cancel", role: .cancel) {
                viewModel.editingDefaultsExercise = nil
            }
            Button("Apply") {
                viewModel.handle(.applyEditing(exercise))
            }
        }
    }

    private var muscleMapSectionView: some View {
        CustomSectionView(header: "Muscle groups to target") {
            MuscleMapView(exercises: viewModel.exercises.map(\.exerciseModel))
                .clippedWithPaddingAndBackground(.surface)
                .onAppear { isMuscleMapVisible = true }
                .onDisappear { isMuscleMapVisible = false }
        }
    }

    private var workoutNameSectionView: some View {
        CustomSectionView(header: "Workout Name") {
            TextField("Legs day", text: $viewModel.workoutName, axis: .vertical)
                .focused($isNameFocused)
                .clippedWithPaddingAndBackground(.surface)
        } headerTrailingContent: {
            if isNameFocused {
                Button("Done") {
                    isNameFocused = false
                }
            }
        }
    }

    private var notesSectionView: some View {
        CustomSectionView(header: "Notes") {
            TextField("Something you might need", text: $viewModel.workoutNotes, axis: .vertical)
                .focused($isNotesFocused)
                .clippedWithPaddingAndBackground(.surface)
        } headerTrailingContent: {
            if isNotesFocused {
                Button("Done") {
                    isNotesFocused = false
                }
            }
        }
    }

    @ViewBuilder
    private var selectedExerciseSectionView: some View {
        if viewModel.exercises.isNotEmpty {
            VStack(spacing: 8) {
                Section {
                    ListWithDivider(viewModel.exercises) { exercise in
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(exercise.exerciseModel.name)
                                    .bold()
                                    .foregroundStyle(.primary)
                                Text(exercise.exerciseModel.categoriesLocalizedNames)
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Default sets: \(exercise.defaultSets.formatted())")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                Text("Default reps: \(exercise.defaultReps.formatted())")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .contextMenu {
                            Button("Edit defaults") {
                                viewModel.handle(.editDefaults(exercise))
                            }
                            Button("Remove", role: .destructive) {
                                viewModel.handle(.toggleExerciseSelection(exercise.exerciseModel))
                            }
                        }
                    }
                    .clippedWithBackground(Color.surface)
                } header: {
                    CustomSectionHeader(text: "Selected exercises")
                }
            }
        }
    }

    private func exerciseCategorySectionView(for category: ExerciseCategory) -> some View {
        CustomSectionView(header: LocalizedStringKey(category.name)) {
            let filteredExercises = category.exercises.filter {
                viewModel.selectedEquipment.contains($0.equipment)
            }
            if filteredExercises.isNotEmpty {
                HFlow {
                    ForEach(filteredExercises, id: \.rawValue) { model in
                        capsuleView(
                            for: model,
                            isSelected: viewModel.exercises.contains(
                                where: { $0.exerciseModel.rawValue == model.rawValue }
                            )
                        )
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
    private func capsuleView(for item: ExerciseModel, isSelected: Bool) -> some View {
        if isSelected {
            Button {
                // do nothing
            } label: {
                Text(item.name)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(Capsule())
        } else {
            Button {
                viewModel.handle(.toggleExerciseSelection(item))
                HapticManager.shared.triggerSelection()
            } label: {
                Text(item.name)
            }
            .buttonStyle(.bordered)
            .clipShape(Capsule())
        }
    }

    private var floatingMuscleMapView: some View {
        MuscleMapView(exercises: viewModel.exercises.map(\.exerciseModel))
            .frame(width: 100, height: 100)
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(8)
            .transition(.opacity)
    }
}

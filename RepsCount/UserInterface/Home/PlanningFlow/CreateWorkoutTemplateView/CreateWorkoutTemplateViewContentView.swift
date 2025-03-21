import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core

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
                Button {
                    viewModel.handle(.toggleAddExerciseSheet)
                } label: {
                    Text("Add exercises")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .clippedWithPaddingAndBackground(.surface)
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .background(Color.background)
        .animation(.default, value: isMuscleMapVisible)
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
        .sheet(isPresented: $viewModel.isShowingAddExerciseSheet) {
            AddExerciseView(selectedExercises: viewModel.exercises.map(\.exerciseModel)) { exercise in
                viewModel.handle(.addExercise(exercise))
                viewModel.handle(.toggleAddExerciseSheet)
                HapticManager.shared.triggerNotification(type: .success)
            }
        }
    }

    private var muscleMapSectionView: some View {
        CustomSectionView(header: "Muscle groups to target") {
            MuscleMapImageView(exercises: viewModel.exercises.map(\.exerciseModel), width: 250)
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
                        .background(Color.systemBackground.opacity(0.02))
                        .contextMenu {
                            Button("Edit defaults") {
                                viewModel.handle(.editDefaults(exercise))
                            }
                            Button("Remove", role: .destructive) {
                                viewModel.handle(.removeExercise(exercise))
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
}

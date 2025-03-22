import SwiftUI
import CoreUserInterface
import Core
import struct Services.AnalyticsService

public struct CreateWorkoutTemplateViewContentView: PageView {

    public typealias ViewModel = CreateWorkoutTemplateViewViewModel

    @ObservedObject public var viewModel: ViewModel
    @FocusState private var isNameFocused: Bool
    @FocusState private var isNotesFocused: Bool

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
                    AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenAddExerciseButtonTapped)
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.handle(.toggleAddExerciseSheet)
                    AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenAddExerciseMenuButtonTapped)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                viewModel.handle(.saveTemplate)
                AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenSaveButtonTapped)
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
            TextField("Sets (optional)", text: $viewModel.defaultSetsInput)
                .keyboardType(.numberPad)
            switch exercise.exerciseModel.metricType {
            case .weightAndReps:
                TextField("Reps (optional)", text: $viewModel.defaultAmountInput)
                    .keyboardType(.numberPad)
            case .time:
                TextField("Time (sec, optional)", text: $viewModel.defaultAmountInput)
                    .keyboardType(.numberPad)
            @unknown default:
                fatalError()
            }
            Button("Cancel", role: .cancel) {
                viewModel.editingDefaultsExercise = nil
                AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenCancelEditButtonTapped)
            }
            Button("Apply") {
                viewModel.handle(.applyEditing(exercise))
                AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenApplyEditButtonTapped)
            }
        }
        .sheet(isPresented: $viewModel.isShowingAddExerciseSheet) {
            AddExerciseView(selectedExercises: viewModel.exercises.map(\.exerciseModel)) { exercise in
                viewModel.handle(.addExercise(exercise))
                viewModel.handle(.toggleAddExerciseSheet)
                HapticManager.shared.triggerNotification(type: .success)
                AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenExerciseAdded)
            }
        }
        .onAppear {
            AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenOpened)
        }
    }

    private var muscleMapSectionView: some View {
        CustomSectionView(header: "Muscle groups to target") {
            MuscleMapImageView(exercises: viewModel.exercises.map(\.exerciseModel), width: 250)
                .clippedWithPaddingAndBackground(.surface)
        }
    }

    private var workoutNameSectionView: some View {
        CustomSectionView(header: "Workout Name") {
            TextField(
                "Legs day",
                text: $viewModel.workoutName,
                axis: .vertical
            )
            .focused($isNameFocused)
            .clippedWithPaddingAndBackground(.surface)
        } headerTrailingContent: {
            if isNameFocused {
                Button("Done") {
                    isNameFocused = false
                    AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenNameChanged)
                }
            }
        }
    }

    private var notesSectionView: some View {
        CustomSectionView(header: "Notes") {
            TextField(
                "Something you might need",
                text: $viewModel.workoutNotes,
                axis: .vertical
            )
            .focused($isNotesFocused)
            .clippedWithPaddingAndBackground(.surface)
        } headerTrailingContent: {
            if isNotesFocused {
                Button("Done") {
                    isNotesFocused = false
                    AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenNotesChanged)
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
                        HStack(spacing: 12) {
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
                                Text("Sets: \(exercise.defaultSets.formatted())")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                switch exercise.exerciseModel.metricType {
                                case .weightAndReps:
                                    Text("Reps: \(exercise.defaultAmount.formatted())")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                case .time:
                                    Text("Time (sec): \(exercise.defaultAmount.formatted())")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                @unknown default:
                                    fatalError()
                                }
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color.systemBackground.opacity(0.02))
                        .contextMenu {
                            Button("Edit defaults") {
                                viewModel.handle(.editDefaults(exercise))
                                AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenExerciseEditButtonTapped)
                            }
                            Button("Remove", role: .destructive) {
                                viewModel.handle(.removeExercise(exercise))
                                AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenExerciseRemoveButtonTapped)
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

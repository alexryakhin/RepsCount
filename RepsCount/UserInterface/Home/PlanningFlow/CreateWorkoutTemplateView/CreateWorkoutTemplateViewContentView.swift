import SwiftUI

struct CreateWorkoutTemplateViewContentView: PageView {

    typealias ViewModel = CreateWorkoutTemplateViewViewModel

    @ObservedObject var viewModel: ViewModel
    @FocusState private var isNameFocused: Bool
    @FocusState private var isNotesFocused: Bool

    init(viewModel: CreateWorkoutTemplateViewViewModel) {
        self.viewModel = viewModel
    }

    var contentView: some View {
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
                .clippedWithPaddingAndBackground()
            }
            .padding(vertical: 12, horizontal: 16)
        }
        .background(Color(.systemGroupedBackground))
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
            if !viewModel.isEditing {
                Button {
                    viewModel.handle(.saveTemplate)
                    AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenSaveButtonTapped)
                } label: {
                    Text("Create Template")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .cornerRadius(12)
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
        }
        .alert("Edit", isPresented: .constant(viewModel.editingDefaultsExercise != nil), presenting: viewModel.editingDefaultsExercise) { exercise in
            TextField("Sets (optional)", text: $viewModel.defaultSetsInput)
                .keyboardType(.numberPad)
            let textFieldTitleKey: LocalizedStringKey = switch exercise.exerciseModel.metricType {
            case .reps: "Reps (optional)"
            case .time: "Time (sec, optional)"
            @unknown default:
                fatalError()
            }
            TextField(textFieldTitleKey, text: $viewModel.defaultAmountInput)
                .keyboardType(.numberPad)

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
                .clippedWithPaddingAndBackground()
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
            .clippedWithPaddingAndBackground()
        } headerTrailingContent: {
            if isNameFocused {
                Button("Done") {
                    viewModel.handle(.updateName)
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
            .clippedWithPaddingAndBackground()
        } headerTrailingContent: {
            if isNotesFocused {
                Button("Done") {
                    viewModel.handle(.updateNotes)
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
                        SwipeToDeleteView {
                            WorkoutTemplateExerciseRow(exercise: exercise) {
                                viewModel.handle(.editDefaults(exercise))
                                AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenExerciseEditButtonTapped)
                            }
                            .padding(vertical: 12, horizontal: 16)
                        } onDelete: {
                            viewModel.handle(.removeExercise(exercise))
                            AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenExerciseRemoveButtonTapped)
                        }
                    }
                    .clippedWithBackground()
                } header: {
                    CustomSectionHeader("Selected exercises")
                        .padding(.horizontal, 12)
                }
            }
        }
    }
}

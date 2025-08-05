import SwiftUI

struct CreateWorkoutTemplateViewContentView: View {

    @ObservedObject var viewModel: CreateWorkoutTemplateViewViewModel
    @FocusState private var isNameFocused: Bool
    @FocusState private var isNotesFocused: Bool

    init(viewModel: CreateWorkoutTemplateViewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                muscleMapSectionView
                workoutNameSectionView
                notesSectionView
                selectedExerciseSectionView
                addExerciseButtonView
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
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
            TextField(Loc.ExerciseDetails.setsOptional.localized, text: $viewModel.defaultSetsInput)
                .keyboardType(.numberPad)
            let textFieldTitleKey: String = switch exercise.exerciseModel.metricType {
            case .reps: Loc.ExerciseDetails.repsOptional
            case .time: Loc.ExerciseDetails.timeOptional
            @unknown default:
                fatalError()
            }
            TextField(textFieldTitleKey.localized, text: $viewModel.defaultAmountInput)
                .keyboardType(.numberPad)

                            Button(Loc.Common.cancel.localized, role: .cancel) {
                viewModel.editingDefaultsExercise = nil
                AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenCancelEditButtonTapped)
            }
                            Button(Loc.Common.apply.localized) {
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
        .additionalState(viewModel.additionalState)
        .withAlertManager()
        .onAppear {
            AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenOpened)
        }
    }

    private var muscleMapSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Loc.Planning.muscleGroupsToTarget.localized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                
                MuscleMapImageView(exercises: viewModel.exercises.map(\.exerciseModel), width: 250)
                    .padding(20)
            }
        }
    }

    private var workoutNameSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Loc.Planning.workoutName.localized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isNameFocused {
                    Button(Loc.Common.done.localized) {
                        viewModel.handle(.updateName)
                        isNameFocused = false
                        AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenNameChanged)
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                }
            }
            
            TextField(
                "Legs day",
                text: $viewModel.workoutName,
                axis: .vertical
            )
            .focused($isNameFocused)
            .font(.subheadline)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
    }

    private var notesSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Loc.WorkoutDetails.notes.localized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isNotesFocused {
                    Button(Loc.Common.done.localized) {
                        viewModel.handle(.updateNotes)
                        isNotesFocused = false
                        AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenNotesChanged)
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                }
            }
            
            TextField(
                "Something you might need",
                text: $viewModel.workoutNotes,
                axis: .vertical
            )
            .focused($isNotesFocused)
            .font(.subheadline)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
    }

    @ViewBuilder
    private var selectedExerciseSectionView: some View {
        if viewModel.exercises.isNotEmpty {
            VStack(spacing: 16) {
                HStack {
                    Text(Loc.Planning.selectedExercises.localized)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                VStack(spacing: 8) {
                    ForEach(viewModel.exercises) { exercise in
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
                        .clippedWithBackground()
                    }
                }
            }
        }
    }
    
    private var addExerciseButtonView: some View {
        Button {
            viewModel.handle(.toggleAddExerciseSheet)
            AnalyticsService.shared.logEvent(.workoutTemplateDetailsScreenAddExerciseButtonTapped)
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Add exercises")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Select exercises for your template")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

import SwiftUI

struct WorkoutDetailsContentView: View {

    @ObservedObject var viewModel: WorkoutDetailsViewModel

    init(viewModel: WorkoutDetailsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                HStack(spacing: 8) {
                    muscleMapSectionView
                    statisticsSectionView
                }
                exercisesSectionView
                notesSectionView
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemGroupedBackground))
        .animation(.default, value: viewModel.workout)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    if !viewModel.workout.isCompleted {
                        Button {
                            viewModel.handle(.showAddExercise)
                            AnalyticsService.shared.logEvent(.workoutDetailsAddExerciseMenuButtonTapped)
                        } label: {
                            Label(Loc.WorkoutDetails.addExercise.localized, systemImage: "plus")
                        }

                        Button {
                            viewModel.handle(.markAsComplete)
                            AnalyticsService.shared.logEvent(.workoutDetailsMarkAsCompleteMenuButtonTapped)
                        } label: {
                            Label(Loc.WorkoutDetails.markAsComplete.localized, systemImage: "flag.fill")
                        }
                    }
                    Button {
                        viewModel.handle(.renameWorkout)
                        AnalyticsService.shared.logEvent(.workoutDetailsRenameMenuButtonTapped)
                    } label: {
                        Label(Loc.Common.rename.localized, systemImage: "pencil")
                    }
                    Section {
                        Button(role: .destructive) {
                            viewModel.handle(.showDeleteWorkoutAlert)
                            AnalyticsService.shared.logEvent(.workoutDetailsDeleteMenuButtonTapped)
                        } label: {
                            Label(Loc.WorkoutDetails.deleteWorkout.localized, systemImage: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert(Loc.WorkoutDetails.renameWorkout.localized, isPresented: $viewModel.isShowingAlertToRenameWorkout) {
            TextField(Loc.WorkoutDetails.enterName.localized, text: $viewModel.nameInput)
            Button(Loc.Common.cancel.localized, role: .cancel) {
                AnalyticsService.shared.logEvent(.workoutDetailsRenameWorkoutCancelTapped)
            }
            Button(Loc.Common.rename.localized) {
                viewModel.handle(.updateName(viewModel.nameInput))
                AnalyticsService.shared.logEvent(.workoutDetailsRenameWorkoutActionTapped)
            }
        }
        .sheet(isPresented: $viewModel.isShowingAddExerciseSheet) {
            AddExerciseView(selectedExercises: viewModel.workout.exercises.map(\.model)) {
                viewModel.handle(.addExercise($0))
                viewModel.isShowingAddExerciseSheet = false
                HapticManager.shared.triggerNotification(type: .success)
            }
        }
        .additionalState(viewModel.additionalState)
        .withAlertManager()
        .onAppear {
            AnalyticsService.shared.logEvent(.workoutDetailsScreenOpened)
        }
    }

    @ViewBuilder
    private var exercisesSectionView: some View {
        if viewModel.workout.exercises.isNotEmpty {
            VStack(spacing: 8) {
                Section {
                    ForEach(viewModel.workout.exercises) { exercise in
                        Button {
                            viewModel.handle(.showExerciseDetails(exercise))
                            AnalyticsService.shared.logEvent(.workoutDetailsExerciseSelected)
                        } label: {
                            SwipeToDeleteView {
                                ExerciseListCellView(exercise: exercise)
                                    .padding(vertical: 12, horizontal: 16)
                            } onDelete: {
                                viewModel.handle(.showDeleteExerciseAlert(exercise))
                                AnalyticsService.shared.logEvent(.workoutDetailsExerciseRemoveButtonTapped)
                            }
                            .clippedWithBackground()
                        }
                    }
                } header: {
                    CustomSectionHeader(Loc.WorkoutDetails.exercises.localized)
                        .padding(.horizontal, 12)
                }
            }
        } else {
            EmptyListView(
                label: Loc.WorkoutDetails.noExercisesYet.localized,
                description: Loc.WorkoutDetails.noExercisesDescription.localized,
                background: .clear
            ) {
                Button(Loc.WorkoutDetails.addExercise.localized) {
                    viewModel.handle(.showAddExercise)
                    AnalyticsService.shared.logEvent(.workoutDetailsAddExerciseButtonTapped)
                }
                .buttonStyle(.borderedProminent)
            }
            .clippedWithPaddingAndBackground()
        }
    }

    private var muscleMapSectionView: some View {
        CustomSectionView(header: Loc.WorkoutDetails.targetMuscles.localized) {
            MuscleMapImageView(exercises: viewModel.workout.exercises.map(\.model), width: 100)
                .clippedWithPaddingAndBackground()
        }
    }

    private var statisticsSectionView: some View {
        CustomSectionView(header: Loc.WorkoutDetails.info.localized) {
            FormWithDivider {
                infoCell(
                    label: Loc.WorkoutDetails.exercises.localized,
                    info: viewModel.workout.exercises.count.formatted()
                )
                if let totalDuration = viewModel.workout.totalDuration?.formatted(with: [.hour, .minute]) {
                    infoCell(
                        label: Loc.Time.time.localized,
                        info: totalDuration
                    )
                }
            }
            .clippedWithBackground()
        }
    }

    @ViewBuilder
    private var notesSectionView: some View {
        if let notes = viewModel.workout.workoutTemplate?.notes?.nilIfEmpty {
            CustomSectionView(header: Loc.WorkoutDetails.notes.localized) {
                Text(notes)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .clippedWithPaddingAndBackground()
            }
        }
    }

    private func infoCell(label: String, info: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            Text(info)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

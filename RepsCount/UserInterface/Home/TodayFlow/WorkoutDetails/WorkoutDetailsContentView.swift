import SwiftUI

struct WorkoutDetailsContentView: View {

    struct StatCardView: View {
        let title: String
        let value: String
        let icon: String
        let color: Color

        var body: some View {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)

                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }

                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.tertiarySystemGroupedBackground))
            )
        }
    }

    @ObservedObject var viewModel: WorkoutDetailsViewModel

    init(viewModel: WorkoutDetailsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                HStack(spacing: 12) {
                    muscleMapSectionView
                    statisticsSectionView
                }
                exercisesSectionView
                notesSectionView
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
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
        VStack(spacing: 16) {
            HStack {
                Text(Loc.WorkoutDetails.targetMuscles.localized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                
                MuscleMapImageView(exercises: viewModel.workout.exercises.map(\.model), width: 120)
                    .padding(20)
            }
        }
    }

    private var statisticsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Loc.WorkoutDetails.info.localized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                StatCardView(
                    title: Loc.WorkoutDetails.exercises.localized,
                    value: viewModel.workout.exercises.count.formatted(),
                    icon: "dumbbell.fill",
                    color: .blue
                )
                
                if let totalDuration = viewModel.workout.totalDuration?.formatted(with: [.hour, .minute]) {
                    StatCardView(
                        title: Loc.Time.time.localized,
                        value: totalDuration,
                        icon: "clock.fill",
                        color: .green
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var notesSectionView: some View {
        if let notes = viewModel.workout.workoutTemplate?.notes?.nilIfEmpty {
            VStack(spacing: 16) {
                HStack {
                    Text(Loc.WorkoutDetails.notes.localized)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                Text(notes)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemGroupedBackground))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    )
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

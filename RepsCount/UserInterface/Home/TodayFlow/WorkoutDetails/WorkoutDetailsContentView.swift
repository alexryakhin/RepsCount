import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core
import struct Services.AnalyticsService

public struct WorkoutDetailsContentView: PageView {

    public typealias ViewModel = WorkoutDetailsViewModel

    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: WorkoutDetailsViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                HStack(spacing: 8) {
                    muscleMapSectionView
                    statisticsSectionView
                }
                exercisesSectionView
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.background)
        .animation(.default, value: viewModel.workout)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    if !viewModel.workout.isCompleted {
                        Button {
                            viewModel.handle(.showAddExercise)
                            AnalyticsService.shared.logEvent(.workoutDetailsAddExerciseMenuButtonTapped)
                        } label: {
                            Label("Add exercise", systemImage: "plus")
                        }

                        Button {
                            viewModel.handle(.markAsComplete)
                            AnalyticsService.shared.logEvent(.workoutDetailsMarkAsCompleteMenuButtonTapped)
                        } label: {
                            Label("Mark as complete", systemImage: "flag.fill")
                        }
                    }
                    Button {
                        viewModel.handle(.renameWorkout)
                        AnalyticsService.shared.logEvent(.workoutDetailsRenameMenuButtonTapped)
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    Section {
                        Button(role: .destructive) {
                            viewModel.handle(.showDeleteWorkoutAlert)
                            AnalyticsService.shared.logEvent(.workoutDetailsDeleteMenuButtonTapped)
                        } label: {
                            Label("Delete workout", systemImage: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .alert("Rename workout", isPresented: $viewModel.isShowingAlertToRenameWorkout) {
            TextField("Enter name", text: $viewModel.nameInput)
            Button("Cancel", role: .cancel) {
                AnalyticsService.shared.logEvent(.workoutDetailsRenameWorkoutCancelTapped)
            }
            Button("Rename") {
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
                            ExerciseListCellView(
                                model: .init(
                                    exercise: exercise.model.name,
                                    categories: exercise.model.categoriesLocalizedNames
                                )
                            )
                            .clippedWithPaddingAndBackground(.surface)
                            .contextMenu {
                                Button("Delete", role: .destructive) {
                                    viewModel.handle(.showDeleteExerciseAlert(exercise))
                                    AnalyticsService.shared.logEvent(.workoutDetailsExerciseRemoveButtonTapped)
                                }
                            }
                        }
                    }
                } header: {
                    CustomSectionHeader(text: "Exercises")
                }
            }
        } else {
            EmptyListView(
                label: "No exercises yet",
                description: "Select 'Add exercise' from the menu in the top right corner",
                background: .clear
            ) {
                Button("Add exercise") {
                    viewModel.handle(.showAddExercise)
                    AnalyticsService.shared.logEvent(.workoutDetailsAddExerciseButtonTapped)
                }
                .buttonStyle(.borderedProminent)
            }
            .clippedWithPaddingAndBackground(.surface)
        }
    }

    private var muscleMapSectionView: some View {
        CustomSectionView(header: "Target muscles") {
            MuscleMapImageView(exercises: viewModel.workout.exercises.map(\.model), width: 100)
                .clippedWithPaddingAndBackground(.surface)
        }
    }

    private var statisticsSectionView: some View {
        CustomSectionView(header: "Info") {
            FormWithDivider {
                infoCell(
                    label: "Exercises",
                    info: viewModel.workout.exercises.count.formatted()
                )
                if let totalDuration = viewModel.workout.totalDuration?.hoursAndMinutes {
                    infoCell(
                        label: "Time",
                        info: totalDuration
                    )
                }
            }
            .clippedWithBackground(Color.surface)
        }
    }

    private func infoCell(label: LocalizedStringKey, info: String) -> some View {
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

import SwiftUI
import CoreUserInterface
import Core
import struct Services.AnalyticsService

public struct TodayMainContentView: PageView {

    public typealias ViewModel = TodayMainViewModel

    @AppStorage(UDKeys.isShowingOnboarding) var isShowingOnboarding: Bool = true
    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: TodayMainViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        ScrollViewWithCustomNavBar {
            LazyVStack(spacing: 24) {
                todayWorkoutsSectionView
                    .animation(.default, value: viewModel.todayWorkouts)
                plannedWorkoutsSectionView
                    .animation(.default, value: viewModel.plannedWorkouts)
            }
            .padding(.horizontal, 16)
        } navigationBar: {
            navigationBarView
        }
        .background(Color.background)
        .sheet(isPresented: $viewModel.isShowingAddWorkoutFromTemplate) {
            templateSelectionView
        }
        .sheet(isPresented: $isShowingOnboarding) {
            isShowingOnboarding = false
        } content: {
            OnboardingView()
        }
        .onAppear {
            AnalyticsService.shared.logEvent(.todayScreenOpened)
        }
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        VStack {
            navigationBarView
            Spacer()
            EmptyListView(label: "No Workout Planned", description: "You haven't planned any workouts for today.") {
                VStack(spacing: 10) {
                    if viewModel.workoutTemplates.isNotEmpty {
                        Button("Add Workout from Templates") {
                            viewModel.handle(.showAddWorkoutFromTemplate)
                            AnalyticsService.shared.logEvent(.todayScreenAddWorkoutFromTemplatesButtonTapped)
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    Button("Start a new workout") {
                        viewModel.handle(.createOpenWorkout)
                        AnalyticsService.shared.logEvent(.todayScreenAddNewWorkoutButtonTapped)
                    }
                    .buttonStyle(.bordered)
                }
            }
            Spacer()
        }
    }

    @ViewBuilder
    private var plannedWorkoutsSectionView: some View {
        if viewModel.plannedWorkouts.isNotEmpty {
            VStack(spacing: 8) {
                Section {
                    ForEach(viewModel.plannedWorkouts) { event in
                        Button {
                            viewModel.handle(.startPlannedWorkout(event))
                            AnalyticsService.shared.logEvent(.todayScreenStartPlannedWorkoutTapped)
                        } label: {
                            TodayWorkoutEventRow(event: event)
                                .clippedWithPaddingAndBackground(.surface)
                        }
                    }
                } header: {
                    CustomSectionHeader(text: "Planned workouts")
                }
            }
        }
    }

    @ViewBuilder
    private var todayWorkoutsSectionView: some View {
        if viewModel.todayWorkouts.isNotEmpty {
            VStack(spacing: 8) {
                Section {
                    ForEach(viewModel.todayWorkouts) { workout in
                        Button {
                            viewModel.handle(.showWorkoutDetails(workout))
                            AnalyticsService.shared.logEvent(.todayScreenWorkoutSelected)
                        } label: {
                            TodayWorkoutRow(workout: workout)
                                .clippedWithPaddingAndBackground(.surface)
                                .contextMenu {
                                    Button("Delete", role: .destructive) {
                                        viewModel.handle(.showDeleteWorkoutAlert(workout))
                                        AnalyticsService.shared.logEvent(.todayScreenWorkoutRemoveButtonTapped)
                                    }
                                }
                        }
                    }
                } header: {
                    CustomSectionHeader(text: "Current workouts")
                }
            }
        }
    }

    private var navigationBarView: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                Text(Date.now.formatted(date: .long, time: .omitted)) // e.g., March 16
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Text("Today")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Menu {
                Section {
                    Button {
                        viewModel.handle(.createOpenWorkout)
                        AnalyticsService.shared.logEvent(.todayScreenAddNewWorkoutButtonMenuTapped)
                    } label: {
                        Label("Add open workout", systemImage: "plus")
                    }
                    if viewModel.workoutTemplates.isNotEmpty {
                        Button {
                            viewModel.handle(.showAddWorkoutFromTemplate)
                            AnalyticsService.shared.logEvent(.todayScreenAddWorkoutFromTemplatesMenuButtonTapped)
                        } label: {
                            Label("Add a workout from template", systemImage: "plus.square.on.square")
                        }
                    }
                }
                Section {
                    Button {
                        viewModel.handle(.showAllWorkouts)
                        AnalyticsService.shared.logEvent(.todayScreenShowAllWorkoutsMenuButtonTapped)
                    } label: {
                        Label("Show all workouts", systemImage: "baseball.diamond.bases")
                    }
                    Button {
                        viewModel.handle(.showAllExercises)
                        AnalyticsService.shared.logEvent(.todayScreenShowAllExercisesMenuButtonTapped)
                    } label: {
                        Label("Show all exercises", systemImage: "baseball.diamond.bases.outs.indicator")
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .frame(sideLength: 24)
            }
        }
        .padding(vertical: 12, horizontal: 16)
    }

    private var templateSelectionView: some View {
        NavigationView {
            ScrollView {
                ListWithDivider(viewModel.workoutTemplates) { template in
                    Button {
                        viewModel.isShowingAddWorkoutFromTemplate = false
                        viewModel.handle(.startWorkoutFromTemplate(template))
                        AnalyticsService.shared.logEvent(.todayScreenStartWorkoutFromTemplate)
                    } label: {
                        WorkoutTemplateRow(template: template)
                    }
                    .padding(vertical: 12, horizontal: 16)
                }
                .clippedWithBackground(Color.surface)
                .padding(16)
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Select a template")
        }
    }
}

extension DateFormatter {
    static var shortTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

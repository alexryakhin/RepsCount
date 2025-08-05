import SwiftUI

struct TodayMainContentView: View {

    @AppStorage(UDKeys.isShowingOnboarding) var isShowingOnboarding: Bool = true
    @ObservedObject var viewModel: TodayMainViewModel

    init(viewModel: TodayMainViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Syncing banner
                syncingBannerView
                
                // Key metrics section
                keyMetricsSectionView
                
                // Stress & Energy section
                stressAndEnergySectionView
                
                // Quick actions
                quickActionsSectionView
                
                // Today's workouts
                todayWorkoutsSectionView
                    .animation(.easeInOut(duration: 0.3), value: viewModel.todayWorkouts)
                
                // Planned workouts
                plannedWorkoutsSectionView
                    .animation(.easeInOut(duration: 0.3), value: viewModel.plannedWorkouts)
                
                // Recent runs
                recentRunsSectionView
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .navigationTitle(Loc.Navigation.today.localized)
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $viewModel.isShowingAddWorkoutFromTemplate) {
            templateSelectionView
        }
        .sheet(isPresented: $isShowingOnboarding) {
            isShowingOnboarding = false
        } content: {
            OnboardingView()
        }
        .additionalState(viewModel.additionalState)
        .withAlertManager()
        .onAppear {
            AnalyticsService.shared.logEvent(.todayScreenOpened)
            viewModel.handle(.updateDate)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Section {
                        Button {
                            viewModel.handle(.createOpenWorkout)
                            AnalyticsService.shared.logEvent(.todayScreenAddNewWorkoutButtonMenuTapped)
                        } label: {
                            Label(Loc.Today.addOpenWorkout.localized, systemImage: "plus")
                        }
                        if viewModel.workoutTemplates.isNotEmpty {
                            Button {
                                viewModel.handle(.showAddWorkoutFromTemplate)
                                AnalyticsService.shared.logEvent(.todayScreenAddWorkoutFromTemplatesMenuButtonTapped)
                            } label: {
                                Label(Loc.Today.addWorkoutFromTemplate.localized, systemImage: "plus.square.on.square")
                            }
                        }
                    }
                    Section {
                        Button {
                            viewModel.handle(.showAllWorkouts)
                            AnalyticsService.shared.logEvent(.todayScreenShowAllWorkoutsMenuButtonTapped)
                        } label: {
                            Label(Loc.Today.showAllWorkouts.localized, systemImage: "baseball.diamond.bases")
                        }
                        Button {
                            viewModel.handle(.showAllExercises)
                            AnalyticsService.shared.logEvent(.todayScreenShowAllExercisesMenuButtonTapped)
                        } label: {
                            Label(Loc.Today.showAllExercises.localized, systemImage: "baseball.diamond.bases.outs.indicator")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
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
                                .clippedWithPaddingAndBackground()
                        }
                    }
                } header: {
                    CustomSectionHeader("Planned workouts")
                        .padding(.horizontal, 12)
                }
            }
        }
    }
    
    // MARK: - Syncing Banner
    
    @ViewBuilder
    private var syncingBannerView: some View {
        HStack(spacing: 12) {
            Image(systemName: "arrow.clockwise")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Syncing data...")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
    
    // MARK: - Key Metrics Section
    
    @ViewBuilder
    private var keyMetricsSectionView: some View {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                // Strain
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .stroke(Color.orange.opacity(0.2), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(viewModel.dailyStrain) / 100)
                            .stroke(
                                Color.orange,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1.2), value: viewModel.dailyStrain)
                        
                        VStack(spacing: 2) {
                            Text("\(viewModel.dailyStrain)%")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Text("Strain")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                // Recovery
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .stroke(Color.green.opacity(0.2), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(viewModel.recoveryScore) / 100)
                            .stroke(
                                Color.green,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1.2), value: viewModel.recoveryScore)
                        
                        VStack(spacing: 2) {
                            Text("\(viewModel.recoveryScore)%")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Text("Recovery")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                // Sleep
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .stroke(Color.blue.opacity(0.2), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(viewModel.sleepScore) / 100)
                            .stroke(
                                Color.blue,
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1.2), value: viewModel.sleepScore)
                        
                        VStack(spacing: 2) {
                            Text("\(viewModel.sleepScore)%")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Text("Sleep")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Stress & Energy Section
    
    @ViewBuilder
    private var stressAndEnergySectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Stress & Energy")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 20) {
                // Today's stress
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            
                            Text("Today's stress")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                        
                        Text("Last updated at \(Date().formatted(date: .omitted, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("\(viewModel.stressHighest)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            Text("Highest")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("\(viewModel.stressLowest)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            Text("Lowest")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("\(viewModel.stressAverage)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                Spacer()
                            }
                            Text("Average")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.green, .yellow, .red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                )
                                .frame(width: 80, height: 80)
                            
                            VStack(spacing: 4) {
                                Text("\(viewModel.stressCurrent)")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                Text(viewModel.stressLevel)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack(spacing: 4) {
                            Text("Details")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Divider()
                
                // Energy bar
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "bolt.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        Text("\(viewModel.energyLevel)%")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    
                    HStack(spacing: 2) {
                        ForEach(0..<20, id: \.self) { index in
                            Rectangle()
                                .fill(index < Int(viewModel.energyLevel / 5) ? Color.green : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 20)
                                .cornerRadius(4)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Recovery Section
    
    @ViewBuilder
    private var recoverySectionView: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recovery Score")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Based on sleep, HRV & RHR")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(viewModel.recoveryScore)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(recoveryColor)
                    .contentTransition(.numericText())
            }
            
            ZStack {
                Circle()
                    .stroke(Color(.tertiarySystemGroupedBackground), lineWidth: 10)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.recoveryScore) / 100)
                    .stroke(
                        recoveryColor,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.2), value: viewModel.recoveryScore)
                
                VStack(spacing: 2) {
                    Text("\(viewModel.recoveryScore)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(recoveryColor)
                    Text("Score")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
            
            Text(recoveryDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private var recoveryColor: Color {
        switch viewModel.recoveryScore {
        case 80...100:
            return .green
        case 60...79:
            return .orange
        default:
            return .red
        }
    }
    
    private var recoveryDescription: String {
        switch viewModel.recoveryScore {
        case 80...100:
            return "Great recovery! Ready for intense training."
        case 60...79:
            return "Moderate recovery. Consider lighter training."
        default:
            return "Poor recovery. Focus on rest and recovery."
        }
    }
    
    // MARK: - Strain Section
    
    @ViewBuilder
    private var strainSectionView: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Strain Meter")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Daily training load")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(viewModel.dailyStrain)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(strainColor)
                    .contentTransition(.numericText())
            }
            
            VStack(spacing: 12) {
                HStack(alignment: .center, spacing: 12) {
                    Text("Daily")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(viewModel.dailyStrain)/100")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(strainColor)
                }
                
                ProgressView(value: Double(viewModel.dailyStrain), total: 100)
                    .progressViewStyle(
                        LinearProgressViewStyle(tint: strainColor)
                    )
                    .animation(.easeInOut(duration: 0.8), value: viewModel.dailyStrain)
                    .scaleEffect(y: 1.5)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    private var strainColor: Color {
        switch viewModel.dailyStrain {
        case 0...30:
            return .green
        case 31...60:
            return .orange
        default:
            return .red
        }
    }
    
    // MARK: - Quick Actions Section
    
    @ViewBuilder
    private var quickActionsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Actions")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                Button {
                    viewModel.handle(.createOpenWorkout)
                } label: {
                    QuickActionCardView(
                        title: "Start Workout",
                        subtitle: "Begin a new session",
                        icon: "dumbbell.fill",
                        color: .blue
                    )
                }
                .buttonStyle(ScaleButtonStyle())
                
                Button {
                    viewModel.handle(.startRun)
                } label: {
                    QuickActionCardView(
                        title: "Start Run",
                        subtitle: "Track your run",
                        icon: "figure.run",
                        color: .green
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Recent Runs Section
    
    @ViewBuilder
    private var recentRunsSectionView: some View {
        if !viewModel.recentRuns.isEmpty {
            VStack(spacing: 16) {
                HStack {
                    Text("Recent Runs")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button("View All") {
                        // Navigate to runs list
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                }
                
                VStack(spacing: 8) {
                    ForEach(viewModel.recentRuns) { run in
                        Button {
                            viewModel.handle(.showRunDetails(run))
                        } label: {
                            RunRowView(run: run)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
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
                            SwipeToDeleteView {
                                TodayWorkoutRow(workout: workout)
                                    .padding(vertical: 12, horizontal: 16)
                            } onDelete: {
                                viewModel.handle(.showDeleteWorkoutAlert(workout))
                                AnalyticsService.shared.logEvent(.todayScreenWorkoutRemoveButtonTapped)
                            }
                            .clippedWithBackground()
                        }
                    }
                } header: {
                    CustomSectionHeader("Current workouts")
                        .padding(.horizontal, 12)
                }
            }
        }
    }

    private var navigationBarView: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.currentDate.formatted(date: .long, time: .omitted)) // e.g., March 16
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Text("Today")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
                .clippedWithBackground()
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Loc.Calendar.selectTemplate.localized)
        }
    }
}

// MARK: - Supporting Views

struct QuickActionCardView: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.tertiarySystemGroupedBackground))
        )
    }
}

struct RunRowView: View {
    let run: RunInstance
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "figure.run")
                    .font(.title3)
                    .foregroundColor(.green)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(run.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(String(format: "%.1f km • %@", run.distance, formatDuration(run.duration)))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.1f min/km", run.pace))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.caption2)
                        .foregroundColor(.red)
                    
                    Text("\(run.heartRate)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.tertiarySystemGroupedBackground))
        )
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

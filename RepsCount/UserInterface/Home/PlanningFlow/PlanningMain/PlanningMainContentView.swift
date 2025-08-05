import SwiftUI

struct PlanningMainContentView: View {

    @ObservedObject var viewModel: PlanningMainViewModel

    init(viewModel: PlanningMainViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                calendarSectionView
                trainingPlansSectionView
                templatesSectionView
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .navigationTitle(Loc.Navigation.planning.localized)
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.handle(.createWorkoutTemplate)
                    AnalyticsService.shared.logEvent(.planningScreenAddTemplateMenuButtonTapped)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .additionalState(viewModel.additionalState)
        .withAlertManager()
        .onAppear {
            AnalyticsService.shared.logEvent(.planningScreenOpened)
        }
    }



    private var calendarSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Loc.Navigation.calendar.localized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Button {
                viewModel.handle(.showCalendar)
                AnalyticsService.shared.logEvent(.planningScreenCalendarTapped)
            } label: {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Loc.Planning.scheduleWorkouts.localized)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Text(Loc.Planning.scheduleWorkoutsDescription.localized)
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

    private var templatesSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Loc.Planning.myWorkoutTemplates.localized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                ForEach(viewModel.workoutTemplates) { template in
                    Button {
                        viewModel.handle(.showWorkoutTemplateDetails(template))
                        AnalyticsService.shared.logEvent(.planningScreenTemplateSelected)
                    } label: {
                        SwipeToDeleteView {
                            WorkoutTemplateRow(template: template)
                                .padding(vertical: 12, horizontal: 16)
                        } onDelete: {
                            viewModel.handle(.deleteWorkoutTemplate(template))
                            AnalyticsService.shared.logEvent(.planningScreenTemplateRemoved)
                        }
                        .clippedWithBackground()
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
    
    private var trainingPlansSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Training Plans")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Button {
                viewModel.handle(.showTrainingPlans)
                AnalyticsService.shared.logEvent(.planningScreenTrainingPlansTapped)
            } label: {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "figure.run.square.stack")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Training Plans")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Text("Pre-built and custom training programs")
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
}

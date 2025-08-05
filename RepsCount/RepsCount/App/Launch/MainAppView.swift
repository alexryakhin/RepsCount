//
//  MainAppView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct MainAppView: View {
    
    // MARK: - Properties
    
    @State private var navigationPath = NavigationPath()
    @AppStorage(UDKeys.isShowingOnboarding) var isShowingOnboarding: Bool = true
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView {
                TodayFlowView(navigationPath: $navigationPath)
                    .tabItem {
                        Label(
                            TabBarItem.today.localizedTitle,
                            systemImage: TabBarItem.today.icon
                        )
                    }
                
                PlanningFlowView(navigationPath: $navigationPath)
                    .tabItem {
                        Label(
                            TabBarItem.planning.localizedTitle,
                            systemImage: TabBarItem.planning.icon
                        )
                    }
                
                SettingsFlowView(navigationPath: $navigationPath)
                    .tabItem {
                        Label(
                            TabBarItem.settings.localizedTitle,
                            systemImage: TabBarItem.settings.icon
                        )
                    }
            }
            .navigationDestination(for: WorkoutInstance.self) { workout in
                WorkoutDetailsView(workout: workout, navigationPath: $navigationPath)
            }
            .navigationDestination(for: Exercise.self) { exercise in
                ExerciseDetailsView(exercise: exercise)
            }
            .navigationDestination(for: WorkoutTemplate.self) { template in
                CreateWorkoutTemplateView(workoutTemplateID: template.id)
            }
            .navigationDestination(for: String.self) { id in
                switch id {
                case "workouts_list":
                    WorkoutsListView(navigationPath: $navigationPath)
                case "exercises_list":
                    ExercisesListView(navigationPath: $navigationPath)
                case "calendar":
                    CalendarView(navigationPath: $navigationPath)
                case "about_app":
                    AboutAppView()
                default:
                    EmptyView()
                }
            }
            .navigationDestination(for: ScheduleEventViewModel.ConfigModel.self) { configModel in
                ScheduleEventView(configModel: configModel)
            }
        }
        .sheet(isPresented: $isShowingOnboarding) {
            isShowingOnboarding = false
        } content: {
            OnboardingView()
        }
    }
}

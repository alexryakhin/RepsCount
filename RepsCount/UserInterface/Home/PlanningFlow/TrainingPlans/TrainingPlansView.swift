//
//  TrainingPlansView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct TrainingPlansView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = TrainingPlansViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                prebuiltPlansSectionView
                customPlansSectionView
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Training Plans")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            viewModel.loadTrainingPlans()
            AnalyticsService.shared.logEvent(.trainingPlansOpened)
        }
    }
    
    // MARK: - Pre-built Plans Section
    
    @ViewBuilder
    private var prebuiltPlansSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Pre-built Plans")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(viewModel.prebuiltPlans) { plan in
                    TrainingPlanCardView(plan: plan) {
                        viewModel.handle(.startPlan(plan))
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Custom Plans Section
    
    @ViewBuilder
    private var customPlansSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Custom Plans")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("Create New") {
                    viewModel.handle(.createCustomPlan)
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            if viewModel.customPlans.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    
                    Text("No custom plans yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Create your first training plan")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(32)
                .background(Color(.tertiarySystemGroupedBackground))
                .cornerRadius(8)
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.customPlans) { plan in
                        TrainingPlanCardView(plan: plan) {
                            viewModel.handle(.startPlan(plan))
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Supporting Views

struct TrainingPlanCardView: View {
    let plan: TrainingPlan
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(plan.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(plan.duration) weeks")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(plan.difficulty.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(difficultyColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(difficultyColor.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            HStack(spacing: 12) {
                PlanStatView(
                    title: "Workouts",
                    value: "\(plan.workoutsPerWeek)/week",
                    icon: "dumbbell.fill"
                )
                
                PlanStatView(
                    title: "Focus",
                    value: plan.focus.rawValue,
                    icon: "target"
                )
                
                PlanStatView(
                    title: "Type",
                    value: plan.type.rawValue,
                    icon: "figure.run"
                )
            }
            
            Button(action: onStart) {
                Text("Start Plan")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private var difficultyColor: Color {
        switch plan.difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        }
    }
}

struct PlanStatView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Models

struct TrainingPlan: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let duration: Int
    let difficulty: Difficulty
    let focus: Focus
    let type: PlanType
    let workoutsPerWeek: Int
    let isCustom: Bool
    
    enum Difficulty: String, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }
    
    enum Focus: String, CaseIterable {
        case strength = "Strength"
        case endurance = "Endurance"
        case speed = "Speed"
        case flexibility = "Flexibility"
        case general = "General"
    }
    
    enum PlanType: String, CaseIterable {
        case running = "Running"
        case calisthenics = "Calisthenics"
        case gym = "Gym"
        case mixed = "Mixed"
    }
}

// MARK: - View Model

final class TrainingPlansViewModel: BaseViewModel {
    
    @Published private(set) var prebuiltPlans: [TrainingPlan] = []
    @Published private(set) var customPlans: [TrainingPlan] = []
    
    enum Input {
        case startPlan(TrainingPlan)
        case createCustomPlan
        case editPlan(TrainingPlan)
        case deletePlan(TrainingPlan)
    }
    
    func handle(_ input: Input) {
        switch input {
        case .startPlan(let plan):
            startTrainingPlan(plan)
        case .createCustomPlan:
            createCustomPlan()
        case .editPlan(let plan):
            editPlan(plan)
        case .deletePlan(let plan):
            deletePlan(plan)
        }
    }
    
    func loadTrainingPlans() {
        // Mock pre-built plans
        prebuiltPlans = [
            TrainingPlan(
                name: "5K Training",
                description: "Build endurance and speed for your first 5K race",
                duration: 8,
                difficulty: .beginner,
                focus: .endurance,
                type: .running,
                workoutsPerWeek: 3,
                isCustom: false
            ),
            TrainingPlan(
                name: "Pull-up Progression",
                description: "Master pull-ups from zero to multiple reps",
                duration: 12,
                difficulty: .intermediate,
                focus: .strength,
                type: .calisthenics,
                workoutsPerWeek: 4,
                isCustom: false
            ),
            TrainingPlan(
                name: "Marathon Prep",
                description: "Complete marathon training program",
                duration: 16,
                difficulty: .advanced,
                focus: .endurance,
                type: .running,
                workoutsPerWeek: 5,
                isCustom: false
            ),
            TrainingPlan(
                name: "Strength Building",
                description: "Build muscle and strength in the gym",
                duration: 12,
                difficulty: .intermediate,
                focus: .strength,
                type: .gym,
                workoutsPerWeek: 4,
                isCustom: false
            )
        ]
        
        // Mock custom plans
        customPlans = [
            TrainingPlan(
                name: "My Morning Routine",
                description: "Quick morning workout for energy",
                duration: 4,
                difficulty: .beginner,
                focus: .general,
                type: .mixed,
                workoutsPerWeek: 5,
                isCustom: true
            )
        ]
    }
    
    private func startTrainingPlan(_ plan: TrainingPlan) {
        // Mock plan start
        showAlert(
            withModel: .init(
                title: "Start Training Plan",
                message: "Are you sure you want to start '\(plan.name)'? This will schedule workouts for the next \(plan.duration) weeks.",
                actionText: "Cancel",
                destructiveActionText: nil,
                action: {
                    AnalyticsService.shared.logEvent(.trainingPlanStartCancelled)
                },
                destructiveAction: {
                    AnalyticsService.shared.logEvent(.trainingPlanStarted)
                    HapticManager.shared.triggerNotification(type: .success)
                }
            )
        )
    }
    
    private func createCustomPlan() {
        // Mock custom plan creation
        AnalyticsService.shared.logEvent(.customPlanCreationStarted)
    }
    
    private func editPlan(_ plan: TrainingPlan) {
        // Mock plan editing
        AnalyticsService.shared.logEvent(.trainingPlanEditStarted)
    }
    
    private func deletePlan(_ plan: TrainingPlan) {
        // Mock plan deletion
        AnalyticsService.shared.logEvent(.trainingPlanDeleted)
    }
} 

//
//  AnalyticsDashboardView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct AnalyticsDashboardView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = AnalyticsDashboardViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                strainTrendsSectionView
                recoveryTrendsSectionView
                runningAnalyticsSectionView
                strengthAnalyticsSectionView
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Analytics")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            viewModel.loadAnalyticsData()
            AnalyticsService.shared.logEvent(.analyticsDashboardOpened)
        }
    }
    
    // MARK: - Strain Trends Section
    
    @ViewBuilder
    private var strainTrendsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Strain Trends")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("View Details") {
                    // Navigate to detailed strain view
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 12) {
                // Weekly Strain Chart
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weekly Strain")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.tertiarySystemGroupedBackground))
                            .frame(height: 120)
                        
                        VStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Text("Strain over the past 7 days")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                
                // Strain Stats
                HStack(spacing: 16) {
                    StrainStatCardView(
                        title: "Daily Avg",
                        value: "\(viewModel.dailyStrainAverage)",
                        color: .blue
                    )
                    
                    StrainStatCardView(
                        title: "Weekly Total",
                        value: "\(viewModel.weeklyStrainTotal)",
                        color: .orange
                    )
                    
                    StrainStatCardView(
                        title: "Peak",
                        value: "\(viewModel.peakStrain)",
                        color: .red
                    )
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Recovery Trends Section
    
    @ViewBuilder
    private var recoveryTrendsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recovery Trends")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("View Details") {
                    // Navigate to detailed recovery view
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 12) {
                // Recovery Score Chart
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recovery Score")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.tertiarySystemGroupedBackground))
                            .frame(height: 120)
                        
                        VStack {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            Text("Recovery score over time")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                
                // Recovery Metrics
                HStack(spacing: 16) {
                    RecoveryMetricCardView(
                        title: "Sleep",
                        value: "\(viewModel.averageSleepHours)h",
                        icon: "bed.double.fill",
                        color: .blue
                    )
                    
                    RecoveryMetricCardView(
                        title: "HRV",
                        value: "\(viewModel.averageHRV)ms",
                        icon: "heart.fill",
                        color: .green
                    )
                    
                    RecoveryMetricCardView(
                        title: "RHR",
                        value: "\(viewModel.averageRHR)bpm",
                        icon: "heart.circle.fill",
                        color: .red
                    )
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Running Analytics Section
    
    @ViewBuilder
    private var runningAnalyticsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Running Analytics")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("View Details") {
                    // Navigate to detailed running analytics
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 12) {
                // Pace Chart
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pace Trends")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.tertiarySystemGroupedBackground))
                            .frame(height: 100)
                        
                        VStack {
                            Image(systemName: "speedometer")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Text("Pace improvement over time")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                
                // Running Stats
                HStack(spacing: 16) {
                    RunningStatCardView(
                        title: "Avg Pace",
                        value: String(format: "%.1f min/km", viewModel.averagePace),
                        icon: "speedometer"
                    )
                    
                    RunningStatCardView(
                        title: "Total Distance",
                        value: String(format: "%.1f km", viewModel.totalDistance),
                        icon: "figure.run"
                    )
                    
                    RunningStatCardView(
                        title: "Runs",
                        value: "\(viewModel.totalRuns)",
                        icon: "number.circle.fill"
                    )
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Strength Analytics Section
    
    @ViewBuilder
    private var strengthAnalyticsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Strength Analytics")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("View Details") {
                    // Navigate to detailed strength analytics
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 12) {
                // Volume Chart
                VStack(alignment: .leading, spacing: 8) {
                    Text("Volume Trends")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.tertiarySystemGroupedBackground))
                            .frame(height: 100)
                        
                        VStack {
                            Image(systemName: "chart.bar.fill")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Text("Volume progression by exercise")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                
                // Strength Progress
                ForEach(viewModel.strengthProgress) { progress in
                    StrengthProgressRowView(progress: progress)
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Supporting Views

struct StrainStatCardView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(8)
    }
}

struct RecoveryMetricCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(8)
    }
}

struct RunningStatCardView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.green)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(8)
    }
}

// MARK: - View Model

final class AnalyticsDashboardViewModel: BaseViewModel {
    
    @Published private(set) var dailyStrainAverage: Int = 65
    @Published private(set) var weeklyStrainTotal: Int = 420
    @Published private(set) var peakStrain: Int = 85
    @Published private(set) var averageSleepHours: Double = 7.5
    @Published private(set) var averageHRV: Int = 45
    @Published private(set) var averageRHR: Int = 58
    @Published private(set) var averagePace: Double = 5.8
    @Published private(set) var totalDistance: Double = 45.2
    @Published private(set) var totalRuns: Int = 12
    @Published private(set) var strengthProgress: [ExerciseProgress] = []
    
    func loadAnalyticsData() {
        // Mock data loading
        dailyStrainAverage = Int.random(in: 50...80)
        weeklyStrainTotal = Int.random(in: 300...500)
        peakStrain = Int.random(in: 70...95)
        averageSleepHours = Double.random(in: 6.5...8.5)
        averageHRV = Int.random(in: 35...55)
        averageRHR = Int.random(in: 55...65)
        averagePace = Double.random(in: 5.0...7.0)
        totalDistance = Double.random(in: 30.0...60.0)
        totalRuns = Int.random(in: 8...20)
        
        strengthProgress = [
            ExerciseProgress(exerciseName: "Pull-ups", currentReps: 12, previousReps: 10, sets: 3),
            ExerciseProgress(exerciseName: "Push-ups", currentReps: 25, previousReps: 22, sets: 3),
            ExerciseProgress(exerciseName: "Squats", currentReps: 15, previousReps: 12, sets: 4)
        ]
    }
} 

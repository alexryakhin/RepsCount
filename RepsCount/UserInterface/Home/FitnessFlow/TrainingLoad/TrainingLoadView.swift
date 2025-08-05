//
//  TrainingLoadView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct TrainingLoadView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = TrainingLoadViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                acuteLoadSectionView
                chronicLoadSectionView
                recommendationsSectionView
                loadBalanceSectionView
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Training Load")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            viewModel.loadTrainingLoadData()
            AnalyticsService.shared.logEvent(.trainingLoadOpened)
        }
    }
    
    // MARK: - Acute Load Section
    
    @ViewBuilder
    private var acuteLoadSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Acute Load (7 days)")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(viewModel.acuteLoad)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(acuteLoadColor)
            }
            
            VStack(spacing: 12) {
                // Acute Load Chart
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.tertiarySystemGroupedBackground))
                        .frame(height: 120)
                    
                    VStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("7-day training load")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Acute Load Stats
                HStack(spacing: 16) {
                    LoadStatCardView(
                        title: "Today",
                        value: "\(viewModel.todayLoad)",
                        color: .blue
                    )
                    
                    LoadStatCardView(
                        title: "Yesterday",
                        value: "\(viewModel.yesterdayLoad)",
                        color: .green
                    )
                    
                    LoadStatCardView(
                        title: "Avg/Day",
                        value: "\(viewModel.averageDailyLoad)",
                        color: .orange
                    )
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private var acuteLoadColor: Color {
        switch viewModel.acuteLoad {
        case 0...200:
            return .green
        case 201...400:
            return .orange
        default:
            return .red
        }
    }
    
    // MARK: - Chronic Load Section
    
    @ViewBuilder
    private var chronicLoadSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Chronic Load (28 days)")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(viewModel.chronicLoad)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(chronicLoadColor)
            }
            
            VStack(spacing: 12) {
                // Chronic Load Chart
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.tertiarySystemGroupedBackground))
                        .frame(height: 120)
                    
                    VStack {
                        Image(systemName: "chart.bar.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("28-day average load")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Chronic Load Stats
                HStack(spacing: 16) {
                    LoadStatCardView(
                        title: "Weekly Avg",
                        value: "\(viewModel.weeklyAverageLoad)",
                        color: .blue
                    )
                    
                    LoadStatCardView(
                        title: "Monthly Total",
                        value: "\(viewModel.monthlyTotalLoad)",
                        color: .purple
                    )
                    
                    LoadStatCardView(
                        title: "Trend",
                        value: viewModel.loadTrend > 0 ? "+\(viewModel.loadTrend)" : "\(viewModel.loadTrend)",
                        color: viewModel.loadTrend > 0 ? .green : .red
                    )
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private var chronicLoadColor: Color {
        switch viewModel.chronicLoad {
        case 0...800:
            return .green
        case 801...1200:
            return .orange
        default:
            return .red
        }
    }
    
    // MARK: - Recommendations Section
    
    @ViewBuilder
    private var recommendationsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Training Recommendations")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(viewModel.recommendations) { recommendation in
                    RecommendationCardView(recommendation: recommendation)
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Load Balance Section
    
    @ViewBuilder
    private var loadBalanceSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Load Balance")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(viewModel.loadBalanceRatio, specifier: "%.1f")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(loadBalanceColor)
            }
            
            VStack(spacing: 12) {
                // Load Balance Chart
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.tertiarySystemGroupedBackground))
                        .frame(height: 120)
                    
                    VStack {
                        Image(systemName: "scale.3d")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("Acute vs Chronic load ratio")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Balance Status
                HStack {
                    Text("Status:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(loadBalanceStatus)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(loadBalanceColor)
                    
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private var loadBalanceColor: Color {
        switch viewModel.loadBalanceRatio {
        case 0.8...1.2:
            return .green
        case 0.6...0.79, 1.21...1.4:
            return .orange
        default:
            return .red
        }
    }
    
    private var loadBalanceStatus: String {
        switch viewModel.loadBalanceRatio {
        case 0.8...1.2:
            return "Balanced"
        case 0.6...0.79:
            return "Detraining"
        case 1.21...1.4:
            return "Overreaching"
        default:
            return "Unbalanced"
        }
    }
}

// MARK: - Supporting Views

struct LoadStatCardView: View {
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

struct RecommendationCardView: View {
    let recommendation: TrainingRecommendation
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: recommendation.icon)
                .font(.title2)
                .foregroundColor(recommendation.color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recommendation.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(recommendation.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(8)
    }
}

// MARK: - Models

struct TrainingRecommendation: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
}

// MARK: - View Model

final class TrainingLoadViewModel: BaseViewModel {
    
    @Published private(set) var acuteLoad: Int = 350
    @Published private(set) var chronicLoad: Int = 900
    @Published private(set) var todayLoad: Int = 65
    @Published private(set) var yesterdayLoad: Int = 45
    @Published private(set) var averageDailyLoad: Int = 50
    @Published private(set) var weeklyAverageLoad: Int = 350
    @Published private(set) var monthlyTotalLoad: Int = 900
    @Published private(set) var loadTrend: Int = 15
    @Published private(set) var loadBalanceRatio: Double = 1.1
    @Published private(set) var recommendations: [TrainingRecommendation] = []
    
    func loadTrainingLoadData() {
        // Mock data loading
        acuteLoad = Int.random(in: 250...450)
        chronicLoad = Int.random(in: 800...1100)
        todayLoad = Int.random(in: 40...80)
        yesterdayLoad = Int.random(in: 30...70)
        averageDailyLoad = Int.random(in: 40...60)
        weeklyAverageLoad = Int.random(in: 300...400)
        monthlyTotalLoad = Int.random(in: 800...1100)
        loadTrend = Int.random(in: -20...30)
        loadBalanceRatio = Double.random(in: 0.8...1.4)
        
        recommendations = [
            TrainingRecommendation(
                title: "Maintain Intensity",
                description: "Your load balance is good. Keep current training intensity.",
                icon: "checkmark.circle.fill",
                color: .green
            ),
            TrainingRecommendation(
                title: "Recovery Focus",
                description: "Consider adding a recovery day this week.",
                icon: "heart.fill",
                color: .blue
            ),
            TrainingRecommendation(
                title: "Monitor Progress",
                description: "Track your acute load to prevent overtraining.",
                icon: "eye.fill",
                color: .orange
            )
        ]
    }
} 

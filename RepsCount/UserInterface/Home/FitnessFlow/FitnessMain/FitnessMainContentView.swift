//
//  FitnessMainContentView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct FitnessMainContentView: View {
    
    @ObservedObject var viewModel: FitnessMainViewModel
    
    init(viewModel: FitnessMainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                recoverySectionView
                strainSectionView
                recentRunsSectionView
                strengthProgressSectionView
                weeklyStatsSectionView
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .navigationTitle("Fitness")
        .background(Color(.systemGroupedBackground))
        .refreshable {
            viewModel.handle(.refreshData)
        }
        .onAppear {
            AnalyticsService.shared.logEvent(.fitnessScreenOpened)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        viewModel.handle(.showAnalyticsDashboard)
                    } label: {
                        Label("Analytics Dashboard", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    Button {
                        viewModel.handle(.showTrainingLoad)
                    } label: {
                        Label("Training Load", systemImage: "chart.bar.fill")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
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
            
            VStack(spacing: 16) {
                VStack(spacing: 8) {
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
                
                VStack(spacing: 8) {
                    HStack(alignment: .center, spacing: 12) {
                        Text("Weekly")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("\(viewModel.weeklyStrain)/700")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(strainColor)
                    }
                    
                    ProgressView(value: Double(viewModel.weeklyStrain), total: 700)
                        .progressViewStyle(
                            LinearProgressViewStyle(tint: strainColor)
                        )
                        .animation(.easeInOut(duration: 0.8), value: viewModel.weeklyStrain)
                        .scaleEffect(y: 1.5)
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
                        viewModel.handle(.showAnalyticsDashboard)
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
    
    // MARK: - Strength Progress Section
    
    @ViewBuilder
    private var strengthProgressSectionView: some View {
        if !viewModel.strengthProgress.isEmpty {
            VStack(spacing: 16) {
                HStack {
                    Text("Strength Progress")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                VStack(spacing: 8) {
                    ForEach(viewModel.strengthProgress) { progress in
                        StrengthProgressRowView(progress: progress)
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
    
    // MARK: - Weekly Stats Section
    
    @ViewBuilder
    private var weeklyStatsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("This Week")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCardView(
                    title: "Distance",
                    value: String(format: "%.1f km", viewModel.weeklyDistance),
                    icon: "figure.run",
                    color: .green
                )
                
                StatCardView(
                    title: "Workouts",
                    value: "\(viewModel.weeklyWorkouts)",
                    icon: "dumbbell.fill",
                    color: .blue
                )
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

// MARK: - Supporting Views

struct StrengthProgressRowView: View {
    let progress: ExerciseProgress
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(progress.isImproved ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "dumbbell.fill")
                    .font(.title3)
                    .foregroundColor(progress.isImproved ? .green : .red)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(progress.exerciseName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("\(progress.sets) sets")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(progress.currentReps) reps")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: progress.isImproved ? "arrow.up" : "arrow.down")
                        .font(.caption2)
                        .foregroundColor(progress.isImproved ? .green : .red)
                    
                    Text("\(abs(progress.improvement))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(progress.isImproved ? .green : .red)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.tertiarySystemGroupedBackground))
        )
    }
}

struct StatCardView: View {
    let title: String
    let value: String
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
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
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


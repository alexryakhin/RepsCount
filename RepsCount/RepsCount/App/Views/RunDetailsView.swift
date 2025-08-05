//
//  RunDetailsView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct RunDetailsView: View {
    
    // MARK: - Properties
    
    let run: RunInstance
    @StateObject private var viewModel = RunDetailsViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                runMetricsSectionView
                mapSectionView
                analyticsSectionView
                detailsSectionView
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .navigationTitle("Run Details")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            viewModel.loadRunData(run)
            AnalyticsService.shared.logEvent(.runDetailsScreenOpened)
        }
    }
    
    // MARK: - Run Metrics Section
    
    @ViewBuilder
    private var runMetricsSectionView: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Run Metrics")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Performance overview")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(run.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                MetricCardView(
                    title: "Distance",
                    value: String(format: "%.1f km", run.distance),
                    icon: "figure.run",
                    color: .green
                )
                
                MetricCardView(
                    title: "Duration",
                    value: formatDuration(run.duration),
                    icon: "clock.fill",
                    color: .blue
                )
                
                MetricCardView(
                    title: "Pace",
                    value: String(format: "%.1f min/km", run.pace),
                    icon: "speedometer",
                    color: .orange
                )
                
                MetricCardView(
                    title: "Heart Rate",
                    value: "\(run.heartRate) bpm",
                    icon: "heart.fill",
                    color: .red
                )
                
                MetricCardView(
                    title: "Type",
                    value: run.type == .simple ? "Simple" : "Interval",
                    icon: "repeat",
                    color: .purple
                )
                
                MetricCardView(
                    title: "Calories",
                    value: "\(Int(run.distance * 60))",
                    icon: "flame.fill",
                    color: .orange
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
    
    // MARK: - Map Section
    
    @ViewBuilder
    private var mapSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Route")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.tertiarySystemGroupedBackground))
                    .frame(height: 200)
                
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "map")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    
                    Text("Map View")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("Route visualization with mile markers")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
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
    
    // MARK: - Analytics Section
    
    @ViewBuilder
    private var analyticsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Analytics")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                // Pace Chart
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pace Chart")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.tertiarySystemGroupedBackground))
                            .frame(height: 120)
                        
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color.orange.opacity(0.1))
                                    .frame(width: 48, height: 48)
                                
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                            }
                            
                            Text("Pace over time")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Heart Rate Zones
                VStack(alignment: .leading, spacing: 12) {
                    Text("Heart Rate Zones")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<5) { zone in
                            VStack(spacing: 6) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(heartRateZoneColor(zone))
                                    .frame(height: 60)
                                
                                Text("Z\(zone + 1)")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
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
    
    // MARK: - Details Section
    
    @ViewBuilder
    private var detailsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Details")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                DetailRowView(title: "Weather", value: "Sunny, 22°C")
                DetailRowView(title: "Humidity", value: "45%")
                DetailRowView(title: "Elevation", value: "+150m")
                DetailRowView(title: "Surface", value: "Pavement")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Helper Methods
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func heartRateZoneColor(_ zone: Int) -> Color {
        switch zone {
        case 0: return .blue
        case 1: return .green
        case 2: return .yellow
        case 3: return .orange
        case 4: return .red
        default: return .gray
        }
    }
}

// MARK: - Supporting Views

struct MetricCardView: View {
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
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
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

struct DetailRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - View Model

final class RunDetailsViewModel: BaseViewModel {
    
    @Published private(set) var runData: RunInstance?
    
    func loadRunData(_ run: RunInstance) {
        self.runData = run
    }
} 

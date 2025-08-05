//
//  WorkoutTrackerView.swift
//  RepsCount Watch App
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI
import WatchKit

struct WorkoutTrackerView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = WorkoutTrackerViewModel()
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            workoutControlsView
            repCounterView
            runMetricsView
            recoveryView
        }
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            viewModel.startSession()
        }
    }
    
    // MARK: - Workout Controls View
    
    @ViewBuilder
    private var workoutControlsView: some View {
        VStack(spacing: 16) {
            Text("Workout Tracker")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                Button(action: {
                    viewModel.handle(.startWorkout)
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "play.fill")
                            .font(.title2)
                        Text("Start Workout")
                            .font(.caption)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isWorkoutActive)
                
                Button(action: {
                    viewModel.handle(.startRun)
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: "figure.run")
                            .font(.title2)
                        Text("Start Run")
                            .font(.caption)
                    }
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.isRunActive)
                
                if viewModel.isWorkoutActive || viewModel.isRunActive {
                    Button(action: {
                        viewModel.handle(.stopActivity)
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "stop.fill")
                                .font(.title2)
                            Text("Stop")
                                .font(.caption)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            
            if viewModel.isWorkoutActive || viewModel.isRunActive {
                VStack(spacing: 8) {
                    Text(viewModel.elapsedTime)
                        .font(.title2)
                        .fontWeight(.bold)
                        .monospacedDigit()
                    
                    Text("Elapsed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
    
    // MARK: - Rep Counter View
    
    @ViewBuilder
    private var repCounterView: some View {
        VStack(spacing: 16) {
            Text("Rep Counter")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                Text("\(viewModel.currentReps)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .monospacedDigit()
                
                Text("Reps")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.handle(.decrementReps)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                    }
                    .disabled(viewModel.currentReps == 0)
                    
                    Button(action: {
                        viewModel.handle(.incrementReps)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                
                if viewModel.currentSet > 0 {
                    VStack(spacing: 4) {
                        Text("Set \(viewModel.currentSet)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("\(viewModel.totalReps) total reps")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
    }
    
    // MARK: - Run Metrics View
    
    @ViewBuilder
    private var runMetricsView: some View {
        VStack(spacing: 16) {
            Text("Run Metrics")
                .font(.headline)
                .fontWeight(.semibold)
            
            if viewModel.isRunActive {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Distance")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.2f km", viewModel.distance))
                                .font(.title3)
                                .fontWeight(.semibold)
                                .monospacedDigit()
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Pace")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.1f min/km", viewModel.pace))
                                .font(.title3)
                                .fontWeight(.semibold)
                                .monospacedDigit()
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Heart Rate")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.heartRate) bpm")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .monospacedDigit()
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Calories")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.calories)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .monospacedDigit()
                        }
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "figure.run")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    
                    Text("Start a run to see metrics")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
    }
    
    // MARK: - Recovery View
    
    @ViewBuilder
    private var recoveryView: some View {
        VStack(spacing: 16) {
            Text("Recovery")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 6)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(viewModel.recoveryScore) / 100)
                        .stroke(recoveryColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("\(viewModel.recoveryScore)")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("Score")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                VStack(spacing: 8) {
                    Text("Strain: \(viewModel.strain)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(recoveryDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
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
            return "Great recovery!"
        case 60...79:
            return "Moderate recovery"
        default:
            return "Poor recovery"
        }
    }
}

// MARK: - View Model

final class WorkoutTrackerViewModel: ObservableObject {
    
    @Published private(set) var isWorkoutActive = false
    @Published private(set) var isRunActive = false
    @Published private(set) var elapsedTime = "00:00"
    @Published private(set) var currentReps = 0
    @Published private(set) var currentSet = 0
    @Published private(set) var totalReps = 0
    @Published private(set) var distance: Double = 0.0
    @Published private(set) var pace: Double = 0.0
    @Published private(set) var heartRate = 0
    @Published private(set) var calories = 0
    @Published private(set) var recoveryScore = 85
    @Published private(set) var strain = 65
    
    private var timer: Timer?
    private var startTime: Date?
    
    enum Input {
        case startWorkout
        case startRun
        case stopActivity
        case incrementReps
        case decrementReps
    }
    
    func handle(_ input: Input) {
        switch input {
        case .startWorkout:
            startWorkout()
        case .startRun:
            startRun()
        case .stopActivity:
            stopActivity()
        case .incrementReps:
            incrementReps()
        case .decrementReps:
            decrementReps()
        }
    }
    
    func startSession() {
        // Mock session start
        loadRecoveryData()
    }
    
    private func startWorkout() {
        isWorkoutActive = true
        startTimer()
    }
    
    private func startRun() {
        isRunActive = true
        startTimer()
        startRunMetrics()
    }
    
    private func stopActivity() {
        isWorkoutActive = false
        isRunActive = false
        stopTimer()
        stopRunMetrics()
    }
    
    private func incrementReps() {
        currentReps += 1
        totalReps += 1
    }
    
    private func decrementReps() {
        if currentReps > 0 {
            currentReps -= 1
            totalReps -= 1
        }
    }
    
    private func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        elapsedTime = "00:00"
    }
    
    private func updateElapsedTime() {
        guard let startTime = startTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        elapsedTime = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startRunMetrics() {
        // Mock run metrics
        distance = 0.0
        pace = 6.0
        heartRate = 140
        calories = 0
        
        // Simulate metrics updates
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateRunMetrics()
        }
    }
    
    private func stopRunMetrics() {
        // Stop run metrics updates
    }
    
    private func updateRunMetrics() {
        distance += 0.1
        pace = Double.random(in: 5.5...6.5)
        heartRate = Int.random(in: 135...155)
        calories = Int(distance * 60)
    }
    
    private func loadRecoveryData() {
        // Mock recovery data
        recoveryScore = Int.random(in: 70...95)
        strain = Int.random(in: 40...80)
    }
} 
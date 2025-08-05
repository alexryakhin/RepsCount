//
//  FitnessMainViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Combine
import SwiftUI

final class FitnessMainViewModel: BaseViewModel {
    
    enum Input {
        case showAnalyticsDashboard
        case showTrainingLoad
        case showRunDetails(RunInstance)
        case refreshData
    }
    
    enum Output {
        case showAnalyticsDashboard
        case showTrainingLoad
        case showRunDetails(RunInstance)
    }
    
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Published Properties
    
    @Published private(set) var recoveryScore: Int = 85
    @Published private(set) var dailyStrain: Int = 65
    @Published private(set) var weeklyStrain: Int = 420
    @Published private(set) var recentRuns: [RunInstance] = []
    @Published private(set) var strengthProgress: [ExerciseProgress] = []
    @Published private(set) var weeklyDistance: Double = 12.5
    @Published private(set) var weeklyWorkouts: Int = 4
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        loadMockData()
    }
    
    func handle(_ input: Input) {
        switch input {
        case .showAnalyticsDashboard:
            output.send(.showAnalyticsDashboard)
        case .showTrainingLoad:
            output.send(.showTrainingLoad)
        case .showRunDetails(let run):
            output.send(.showRunDetails(run))
        case .refreshData:
            loadMockData()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadMockData() {
        // Mock recovery data
        recoveryScore = Int.random(in: 70...95)
        dailyStrain = Int.random(in: 40...80)
        weeklyStrain = Int.random(in: 300...500)
        
        // Mock recent runs
        recentRuns = [
            RunInstance(id: UUID(), date: Date().addingTimeInterval(-86400), distance: 5.2, duration: 1800, pace: 5.8, heartRate: 145, type: .simple),
            RunInstance(id: UUID(), date: Date().addingTimeInterval(-172800), distance: 3.1, duration: 1200, pace: 6.2, heartRate: 135, type: .simple),
            RunInstance(id: UUID(), date: Date().addingTimeInterval(-259200), distance: 8.0, duration: 2880, pace: 6.0, heartRate: 150, type: .interval)
        ]
        
        // Mock strength progress
        strengthProgress = [
            ExerciseProgress(exerciseName: "Pull-ups", currentReps: 12, previousReps: 10, sets: 3),
            ExerciseProgress(exerciseName: "Push-ups", currentReps: 25, previousReps: 22, sets: 3),
            ExerciseProgress(exerciseName: "Squats", currentReps: 15, previousReps: 12, sets: 4)
        ]
        
        weeklyDistance = Double.random(in: 10.0...20.0)
        weeklyWorkouts = Int.random(in: 3...6)
    }
}

// MARK: - Mock Models

struct RunInstance: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let distance: Double
    let duration: TimeInterval
    let pace: Double
    let heartRate: Int
    let type: RunType
    
    enum RunType {
        case simple
        case interval
    }
}

struct ExerciseProgress: Identifiable {
    let id = UUID()
    let exerciseName: String
    let currentReps: Int
    let previousReps: Int
    let sets: Int
    
    var improvement: Int {
        currentReps - previousReps
    }
    
    var isImproved: Bool {
        improvement > 0
    }
} 
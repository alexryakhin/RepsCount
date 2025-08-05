import Foundation
import HealthKit

final class WorkoutHealthKitService {
    static let shared = WorkoutHealthKitService()
    
    private let healthKitManager = HealthKitManager.shared
    
    private init() {}
    
    // MARK: - Save Workout to HealthKit
    
    func saveWorkoutToHealthKit(_ workout: WorkoutInstance) async -> Bool {
        guard workout.isCompleted else {
            return false
        }
        
        // Calculate workout duration
        let duration = workout.completionTimeStamp?.timeIntervalSince(workout.date) ?? 0

        // Calculate total energy burned (estimated)
        let totalEnergyBurned = calculateEstimatedCalories(for: workout)
        
        // Calculate total distance (if applicable)
        let totalDistance = calculateTotalDistance(for: workout)
        
        // Determine workout type
        let workoutType = determineWorkoutType(for: workout)
        
        return await healthKitManager.saveWorkout(
            workoutType: workoutType,
            startDate: workout.date,
            endDate: workout.completionTimeStamp ?? workout.date,
            duration: duration,
            totalEnergyBurned: totalEnergyBurned,
            totalDistance: totalDistance
        )
    }
    
    // MARK: - Helper Methods
    
    private func determineWorkoutType(for workout: WorkoutInstance) -> HKWorkoutActivityType {
        // Analyze exercises to determine the most appropriate workout type
        let exercises = workout.exercises.map { $0.model }
        
        // Check for specific exercise types
        if exercises.contains(where: { $0.name.localizedCaseInsensitiveContains("run") }) {
            return .running
        }
        
        if exercises.contains(where: { $0.name.localizedCaseInsensitiveContains("walk") }) {
            return .walking
        }
        
        if exercises.contains(where: { $0.name.localizedCaseInsensitiveContains("bike") || $0.name.localizedCaseInsensitiveContains("cycle") }) {
            return .cycling
        }
        
        if exercises.contains(where: { $0.name.localizedCaseInsensitiveContains("swim") }) {
            return .swimming
        }
        
        // Default to strength training
        return .traditionalStrengthTraining
    }
    
    private func calculateEstimatedCalories(for workout: WorkoutInstance) -> Double? {
        // Simple estimation based on workout duration and exercise count
        let duration = workout.completionTimeStamp?.timeIntervalSince(workout.date) ?? 0
        let exerciseCount = workout.exercises.count
        
        // Base calories per minute for strength training
        let baseCaloriesPerMinute = 6.0
        
        // Additional calories based on exercise count
        let exerciseMultiplier = 1.0 + (Double(exerciseCount) * 0.1)
        
        let estimatedCalories = (duration / 60.0) * baseCaloriesPerMinute * exerciseMultiplier
        
        return estimatedCalories > 0 ? estimatedCalories : nil
    }
    
    private func calculateTotalDistance(for workout: WorkoutInstance) -> Double? {
        // For now, return nil as we don't track distance in strength workouts
        // This could be enhanced to track distance for cardio exercises
        return nil
    }
    
    // MARK: - Fetch HealthKit Data
    
    func fetchRecentHealthKitWorkouts(limit: Int = 10) async -> [HKWorkout] {
        return await healthKitManager.fetchRecentWorkouts(limit: limit)
    }
    
    func fetchHeartRateData(for workout: WorkoutInstance) async -> [HKQuantitySample] {
        let startDate = workout.date
        let endDate = workout.completionTimeStamp ?? workout.date

        return await healthKitManager.fetchHeartRateData(startDate: startDate, endDate: endDate)
    }
} 

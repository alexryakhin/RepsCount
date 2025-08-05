import Foundation
import HealthKit
import Combine

@MainActor
final class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    
    @Published var isHealthKitAvailable = false
    @Published var authorizationStatus: HKAuthorizationStatus = .notDetermined
    
    private init() {
        isHealthKitAvailable = HKHealthStore.isHealthDataAvailable()
    }
    
    // MARK: - Permission Request
    
    func requestPermissions() async -> Bool {
        guard isHealthKitAvailable else {
            return false
        }
        
        let typesToRead: Set<HKObjectType> = [
            // Basic workout data
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.workoutType(),
            
            // Sleep data for recovery
            HKObjectType.categoryType(forIdentifier: .sleepChanges)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,

            // Heart rate variability for recovery and stress
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKObjectType.quantityType(forIdentifier: .heartRateRecoveryOneMinute)!,
            HKObjectType.quantityType(forIdentifier: .walkingHeartRateAverage)!,

            // Resting heart rate for recovery
            HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
            
            // Respiratory rate for stress assessment
            HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,
            
            // Body composition for recovery
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!,
            
            // Activity data for strain calculation
            HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
            
            // VO2 Max for fitness assessment
            HKObjectType.quantityType(forIdentifier: .vo2Max)!,
            
            // Blood pressure for stress assessment
            HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!,
            HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
            
            // Blood oxygen for recovery
            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
        ]
        
        let typesToWrite: Set<HKSampleType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        
        do {
            try await healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead)
            await MainActor.run {
                self.authorizationStatus = .sharingAuthorized
            }
            return true
        } catch {
            print("HealthKit authorization failed: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Save Workout
    
    func saveWorkout(
        workoutType: HKWorkoutActivityType,
        startDate: Date,
        endDate: Date,
        duration: TimeInterval,
        totalEnergyBurned: Double?,
        totalDistance: Double?
    ) async -> Bool {
        guard authorizationStatus == .sharingAuthorized else {
            return false
        }
        
        let workout = HKWorkout(
            activityType: workoutType,
            start: startDate,
            end: endDate,
            duration: duration,
            totalEnergyBurned: totalEnergyBurned.map { HKQuantity(unit: .kilocalorie(), doubleValue: $0) },
            totalDistance: totalDistance.map { HKQuantity(unit: .meter(), doubleValue: $0) },
            metadata: [
                HKMetadataKeyIndoorWorkout: false,
                "com.repscount.app": "RepsCount"
            ]
        )
        
        do {
            try await healthStore.save(workout)
            return true
        } catch {
            print("Failed to save workout to HealthKit: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Read Data
    
    func fetchRecentWorkouts(limit: Int = 10) async -> [HKWorkout] {
        guard authorizationStatus == .sharingAuthorized else {
            return []
        }
        
        let workoutType = HKObjectType.workoutType()
        let predicate = HKQuery.predicateForWorkouts(with: .greaterThan, duration: 0)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        do {
            let workouts: [HKWorkout] = try await withCheckedThrowingContinuation { continuation in
                let query = HKSampleQuery(
                    sampleType: workoutType,
                    predicate: predicate,
                    limit: limit,
                    sortDescriptors: [sortDescriptor]
                ) { _, samples, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        let workouts = samples as? [HKWorkout] ?? []
                        continuation.resume(returning: workouts)
                    }
                }
                healthStore.execute(query)
            }
            return workouts
        } catch {
            print("Failed to fetch workouts: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchHeartRateData(startDate: Date, endDate: Date) async -> [HKQuantitySample] {
        guard authorizationStatus == .sharingAuthorized,
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return []
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        do {
            let samples: [HKQuantitySample] = try await withCheckedThrowingContinuation { continuation in
                let query = HKSampleQuery(
                    sampleType: heartRateType,
                    predicate: predicate,
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [sortDescriptor]
                ) { _, samples, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        let heartRateSamples = samples as? [HKQuantitySample] ?? []
                        continuation.resume(returning: heartRateSamples)
                    }
                }
                healthStore.execute(query)
            }
            return samples
        } catch {
            print("Failed to fetch heart rate data: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Check Authorization Status
    
    func checkAuthorizationStatus() async {
        guard isHealthKitAvailable else {
            await MainActor.run {
                self.authorizationStatus = .notDetermined
            }
            return
        }
        
        let workoutType = HKObjectType.workoutType()
        let status = healthStore.authorizationStatus(for: workoutType)
        
        await MainActor.run {
            self.authorizationStatus = status
        }
    }
} 

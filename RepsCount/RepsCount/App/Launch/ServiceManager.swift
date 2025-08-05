//
//  ServiceManager.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation
import EventKit

final class ServiceManager {
    
    // MARK: - Singleton
    
    static let shared = ServiceManager()
    
    // MARK: - Core Services
    
    lazy var coreDataService: CoreDataServiceInterface = CoreDataService()
    lazy var locationManager: LocationManagerInterface = LocationManager()
    lazy var eventStoreManager: EventStoreManagerInterface = EventStoreManager()
    
    // MARK: - JSON Coders
    
    lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
    
    lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    // MARK: - Data Stores
    
    lazy var eventDataStore: EventDataStore = EventDataStore()
    
    // MARK: - Providers
    
    lazy var exercisesProvider: ExercisesProviderInterface = ExercisesProvider(
        coreDataService: coreDataService
    )
    
    lazy var workoutTemplatesProvider: WorkoutTemplatesProviderInterface = WorkoutTemplatesProvider(
        coreDataService: coreDataService
    )
    
    lazy var workoutEventsProvider: WorkoutEventsProviderInterface = WorkoutEventsProvider(
        coreDataService: coreDataService
    )
    
    lazy var workoutsProvider: WorkoutsProviderInterface = WorkoutsProvider(
        coreDataService: coreDataService
    )
    
    // MARK: - Manager Factories
    
    func createAddExerciseManager() -> AddExerciseManagerInterface {
        AddExerciseManager(
            coreDataService: coreDataService,
            locationManager: locationManager
        )
    }
    
    func createExerciseDetailsManager(exerciseID: String) -> ExerciseDetailsManagerInterface {
        ExerciseDetailsManager(
            exerciseID: exerciseID,
            coreDataService: coreDataService
        )
    }
    
    func createWorkoutTemplateManager(workoutTemplateID: String) -> WorkoutTemplateManagerInterface {
        WorkoutTemplatesManager(
            workoutTemplateID: workoutTemplateID,
            coreDataService: coreDataService
        )
    }
    
    func createWorkoutEventManager() -> WorkoutEventManagerInterface {
        WorkoutEventManager(
            coreDataService: coreDataService
        )
    }
    
    func createAddWorkoutManager() -> AddWorkoutManagerInterface {
        AddWorkoutManager(
            coreDataService: coreDataService,
            locationManager: locationManager
        )
    }
    
    func createWorkoutDetailsManager(workoutID: String) -> WorkoutDetailsManagerInterface {
        WorkoutDetailsManager(
            workoutID: workoutID,
            coreDataService: coreDataService,
            locationManager: locationManager
        )
    }
    
    // MARK: - Private Init
    
    private init() {}
} 
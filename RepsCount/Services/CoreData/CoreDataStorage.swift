//
//  CoreDataStorage.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on January 6, 2025.
//

import CoreData
import Combine

protocol CoreDataStorageInterface {
    var exercisesPublisher: AnyPublisher<[Exercise], CoreError> { get }
    var exerciseCategoriesPublisher: AnyPublisher<[String: [String]], CoreError> { get }

    func addExercise(category: String, exerciseName: String, savesLocation: Bool)
    func deleteExercise(_ exercise: Exercise)
    func fetchExercises()
}

class CoreDataStorage: CoreDataStorageInterface {
    private let coreDataService: CoreDataServiceInterface
    private let locationManager: LocationManager
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let exercisesSubject = CurrentValueSubject<[Exercise], CoreError>([])
    var exercisesPublisher: AnyPublisher<[Exercise], CoreError> {
        return exercisesSubject.eraseToAnyPublisher()
    }

    private let exerciseCategoriesSubject = CurrentValueSubject<[String: [String]], CoreError>([:])
    var exerciseCategoriesPublisher: AnyPublisher<[String: [String]], CoreError> {
        return exerciseCategoriesSubject.eraseToAnyPublisher()
    }

    static let shared: CoreDataStorageInterface = CoreDataStorage(
        coreDataService: CoreDataService.shared,
        locationManager: LocationManager.shared
    )

    private init(coreDataService: CoreDataServiceInterface, locationManager: LocationManager) {
        self.coreDataService = coreDataService
        self.locationManager = locationManager
        fetchExercises()
        fetchCategories()
    }

    func fetchExercises() {
        let request = NSFetchRequest<Exercise>(entityName: "Exercise")
        do {
            let exercises = try coreDataService.context.fetch(request)
            exercisesSubject.send(exercises)
        } catch {
            print("Error fetching exercises. \(error.localizedDescription)")
        }
    }

    func deleteExercise(_ exercise: Exercise) {
        coreDataService.context.delete(exercise)
        save()
    }

    func addExercise(category: String, exerciseName: String, savesLocation: Bool) {
        Task { @MainActor in
            let newItem = Exercise(context: coreDataService.context)
            newItem.timestamp = .now
            newItem.category = category
            newItem.name = exerciseName
            newItem.id = UUID().uuidString
            if savesLocation, let location = await locationManager.getCurrentLocation() {
                newItem.latitude = location.latitude
                newItem.longitude = location.longitude
                newItem.address = location.address
                debugPrint(location)
            }
            save()
        }
    }

    private func fetchCategories() {
        let request = NSFetchRequest<ExerciseModel>(entityName: "ExerciseModel")
        do {
            let models = try coreDataService.context.fetch(request)
            if models.isEmpty {
                setDefaultExercises()
            } else {
                let exerciseCategories = models.reduce(into: [:]) { result, exercise in
                    result[exercise.category ?? "", default: []].append(exercise.name ?? "")
                }
                exerciseCategoriesSubject.send(exerciseCategories)
            }
        } catch {
            print("Error fetching exercises. \(error.localizedDescription)")
        }
    }

    private func setDefaultExercises() {
        GlobalConstant.defaultExerciseCategories.forEach { category, names in
            names.forEach { name in
                let newExerciseModel = ExerciseModel(context: coreDataService.context)
                newExerciseModel.id = UUID().uuidString
                newExerciseModel.name = name
                newExerciseModel.category = category
            }
        }
        save()
        fetchCategories()
    }

    /// Saves all changes in Core Data
    private func save() {
        do {
            try coreDataService.saveContext()
            fetchExercises()
        } catch let error {
            print("Error with saving data to CD. \(error.localizedDescription)")
        }
    }
}

extension ExerciseModel: Comparable {
    public static func < (lhs: ExerciseModel, rhs: ExerciseModel) -> Bool {
        lhs.name ?? "" < rhs.name ?? ""
    }
}

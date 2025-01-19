//
//  ExerciseStorage.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on January 6, 2025.
//

import CoreData
import Combine

protocol ExerciseStorageInterface {
    var exercisesPublisher: AnyPublisher<[Exercise], CoreError> { get }
    var exerciseModelsPublisher: AnyPublisher<[ExerciseModel], CoreError> { get }
    var exerciseCategoriesPublisher: AnyPublisher<[String: [String: [String]]], CoreError> { get }

    func addExercise(category: String, exerciseName: String, savesLocation: Bool)
    func deleteExercise(_ exercise: Exercise)
    func fetchExercises()
}

class ExerciseStorage: ExerciseStorageInterface {
    private let coreDataService: CoreDataServiceInterface
    private let locationManager: LocationManagerInterface
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let exercisesSubject = CurrentValueSubject<[Exercise], CoreError>([])
    var exercisesPublisher: AnyPublisher<[Exercise], CoreError> {
        return exercisesSubject.eraseToAnyPublisher()
    }

    private let exerciseModelsSubject = CurrentValueSubject<[ExerciseModel], CoreError>([])
    var exerciseModelsPublisher: AnyPublisher<[ExerciseModel], CoreError> {
        return exerciseModelsSubject.eraseToAnyPublisher()
    }

    private let exerciseCategoriesSubject = CurrentValueSubject<[String: [String: [String]]], CoreError>([:])
    var exerciseCategoriesPublisher: AnyPublisher<[String: [String: [String]]], CoreError> {
        return exerciseCategoriesSubject.eraseToAnyPublisher()
    }

    init(
        coreDataService: CoreDataServiceInterface,
        locationManager: LocationManagerInterface
    ) {
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
            if models.isEmpty || models.first?.type == nil {
                models.forEach { model in
                    coreDataService.context.delete(model)
                }
                setDefaultExercises()
            } else {
                let exerciseTypes = groupExercises(from: models)
                exerciseModelsSubject.send(models)
                exerciseCategoriesSubject.send(exerciseTypes)
            }
        } catch {
            print("Error fetching exercises. \(error.localizedDescription)")
        }
    }

    private func groupExercises(from models: [ExerciseModel]) -> [String: [String: [String]]] {
        var dictionary: [String: [String: [String]]] = [:]

        for model in models {
            // Get name, type, and category as Strings
            guard
                let name = model.name,
                let typeKey = model.type,
                let categoryKey = model.category
            else { continue }

            // Ensure the outer dictionary contains the type key
            if dictionary[typeKey] == nil {
                dictionary[typeKey] = [:]
            }

            // Ensure the inner dictionary contains the category key
            if dictionary[typeKey]?[categoryKey] == nil {
                dictionary[typeKey]?[categoryKey] = []
            }

            // Append the exercise name to the innermost array
            dictionary[typeKey]?[categoryKey]?.append(name)
        }

        return dictionary
    }

    private func setDefaultExercises() {
        ExerciseModelPreset.presets.forEach { preset in
            let newExerciseModel = ExerciseModel(context: coreDataService.context)
            newExerciseModel.id = UUID().uuidString
            newExerciseModel.name = preset.name
            newExerciseModel.category = preset.category.rawValue
            newExerciseModel.type = preset.type.rawValue
            newExerciseModel.metricType = preset.metricType.rawValue
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

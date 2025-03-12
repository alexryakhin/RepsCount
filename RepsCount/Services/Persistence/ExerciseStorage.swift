//
//  ExerciseStorage.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on January 6, 2025.
//

import CoreData
import Combine
import Core

protocol ExerciseStorageInterface {
    var exercisesPublisher: AnyPublisher<[CDExercise], CoreError> { get }
    var exerciseModelsPublisher: AnyPublisher<[CDExerciseModel], CoreError> { get }
    var exerciseCategoriesPublisher: AnyPublisher<[String: [String: [String]]], CoreError> { get }

    func addExerciseFromExerciseModel(_ model: CDExerciseModel, savesLocation: Bool)
    func deleteExercise(_ exercise: CDExercise)
    func fetchExercises()
}

final class ExerciseStorage: ExerciseStorageInterface {
    private let coreDataService: CoreDataServiceInterface
    private let locationManager: LocationManagerInterface
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let exercisesSubject = CurrentValueSubject<[CDExercise], CoreError>([])
    var exercisesPublisher: AnyPublisher<[CDExercise], CoreError> {
        return exercisesSubject.eraseToAnyPublisher()
    }

    private let exerciseModelsSubject = CurrentValueSubject<[CDExerciseModel], CoreError>([])
    var exerciseModelsPublisher: AnyPublisher<[CDExerciseModel], CoreError> {
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
        let request = NSFetchRequest<CDExercise>(entityName: "Exercise")
        do {
            let exercises = try coreDataService.context.fetch(request)
            exercisesSubject.send(exercises)
        } catch {
            print("Error fetching exercises. \(error.localizedDescription)")
        }
    }

    func deleteExercise(_ exercise: CDExercise) {
        coreDataService.context.delete(exercise)
        save()
    }

    func addExerciseFromExerciseModel(_ model: CDExerciseModel, savesLocation: Bool) {
        Task { @MainActor in
            let newItem = CDExercise(context: coreDataService.context)
            newItem.timestamp = .now
            newItem.category = model.category
            newItem.name = model.name
            newItem.metricType = model.metricType
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
        let request = NSFetchRequest<CDExerciseModel>(entityName: "ExerciseModel")
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

    private func groupExercises(from models: [CDExerciseModel]) -> [String: [String: [String]]] {
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
        ExerciseModel.presets.forEach { preset in
            let newExerciseModel = CDExerciseModel(context: coreDataService.context)
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

extension CDExerciseModel: Comparable {
    public static func < (lhs: CDExerciseModel, rhs: CDExerciseModel) -> Bool {
        lhs.name ?? "" < rhs.name ?? ""
    }
}

//
//  AddExerciseViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/27/24.
//

import SwiftUI
import CoreData
import Combine

final class AddExerciseViewModel: ObservableObject {
    private let persistenceController = PersistenceController.shared
    private let locationManager = LocationManager.shared
    private var cancellable = Set<AnyCancellable>()

    @Published var exerciseCategories: [String: [String]] = [:]

    @Published var text = ""
    @Published var selectedCategory = ""
    @Published var selectedExercise = ""

    init() {
        fetchCategories()
    }

    func addExercise(savesLocation: Bool) {
        Task { @MainActor in
            let newItem = Exercise(context: persistenceController.container.viewContext)
            newItem.timestamp = .now
            newItem.category = selectedCategory
            newItem.name = selectedExercise
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
            let models = try persistenceController.container.viewContext.fetch(request)
            if models.isEmpty {
                setDefaultExercises()
            } else {
                exerciseCategories = models.reduce(into: [:]) { result, exercise in
                    result[exercise.category ?? "", default: []].append(exercise.name ?? "")
                }
                if let firstCategory = exerciseCategories.keys.sorted().first {
                    selectedCategory = firstCategory
                }
                if let firstExercise = exerciseCategories[selectedCategory]?.first {
                    selectedExercise = firstExercise
                }
            }
        } catch {
            print("Error fetching exercises. \(error.localizedDescription)")
        }
    }

    private func setDefaultExercises() {
        GlobalConstant.defaultExerciseCategories.forEach { category, names in
            names.forEach { name in
                let newExerciseModel = ExerciseModel(context: persistenceController.container.viewContext)
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
            try persistenceController.container.viewContext.save()
        } catch let error {
            print("Error with saving data to CD. \(error.localizedDescription)")
        }
        objectWillChange.send()
    }
}

extension ExerciseModel: Comparable {
    public static func < (lhs: ExerciseModel, rhs: ExerciseModel) -> Bool {
        lhs.name ?? "" < rhs.name ?? ""
    }
}

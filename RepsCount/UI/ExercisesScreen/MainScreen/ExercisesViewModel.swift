//
//  ExercisesViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/27/24.
//

import SwiftUI
import Combine
import CoreData

final class ExercisesViewModel: ObservableObject {
    private let persistenceController = PersistenceController.shared
    private var cancellable = Set<AnyCancellable>()

    @Published var exercises: [Exercise] = []
    var savesLocation: Bool {
        UserDefaults.standard.bool(forKey: "savesLocation")
    }

    init() {
        fetchExercises()
    }

    func fetchExercises() {
        let request = NSFetchRequest<Exercise>(entityName: "Exercise")
        do {
            exercises = try persistenceController.container.viewContext.fetch(request)
        } catch {
            print("Error fetching exercises. \(error.localizedDescription)")
        }
    }

    func deleteExercise(_ exercise: Exercise) {
        persistenceController.container.viewContext.delete(exercise)
        save()
    }

    private func save() {
        do {
            try persistenceController.container.viewContext.save()
            fetchExercises()
        } catch let error {
            print("Error with saving data to CD. \(error.localizedDescription)")
        }
        objectWillChange.send()
    }
}

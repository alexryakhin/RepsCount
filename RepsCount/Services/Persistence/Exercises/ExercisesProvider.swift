//
//  ExercisesProvider.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on January 6, 2025.
//

import CoreData
import Combine

protocol ExercisesProviderInterface {
    var exercisesPublisher: AnyPublisher<[Exercise], Never> { get }
    var exercisesErrorPublisher: PassthroughSubject<CoreError, Never> { get }

    func delete(with id: String)
    func fetchExercises()
}

final class ExercisesProvider: ExercisesProviderInterface {

    var exercisesPublisher: AnyPublisher<[Exercise], Never> {
        return exercisesSubject.eraseToAnyPublisher()
    }

    let exercisesErrorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface
    private let exercisesSubject = CurrentValueSubject<[Exercise], Never>([])
    private var cancellables: Set<AnyCancellable> = []

    init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
        setupBindings()
        fetchExercises()
    }

    func fetchExercises() {
        let request = CDExercise.fetchRequest()
        do {
            let exercises = try coreDataService.context.fetch(request)
            exercisesSubject.send(exercises.compactMap(\.coreModel))
        } catch {
            exercisesErrorPublisher.send(.storageError(.readFailed))
        }
    }

    func delete(with id: String) {
        let request = CDExercise.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            if let object = try coreDataService.context.fetch(request).first {
                coreDataService.context.delete(object)
                try coreDataService.saveContext()
            } else {
                throw CoreError.internalError(.removingExerciseFailed)
            }
        } catch {
            exercisesErrorPublisher.send(.internalError(.removingExerciseFailed))
        }
    }

    private func setupBindings() {
        coreDataService.dataUpdatedPublisher
            .sink { [weak self] _ in
                self?.fetchExercises()
            }
            .store(in: &cancellables)
    }
}

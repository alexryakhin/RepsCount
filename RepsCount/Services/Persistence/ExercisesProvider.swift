//
//  ExercisesProvider.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on January 6, 2025.
//

import CoreData
import Combine
import Core

public protocol ExercisesProviderInterface {
    var exercisesPublisher: AnyPublisher<[Exercise], Never> { get }
    var exercisesErrorPublisher: PassthroughSubject<CoreError, Never> { get }

    func delete(with id: String)
    func fetchExercises()
}

public final class ExercisesProvider: ExercisesProviderInterface {

    public var exercisesPublisher: AnyPublisher<[Exercise], Never> {
        return exercisesSubject.eraseToAnyPublisher()
    }

    public let exercisesErrorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface
    private let exercisesSubject = CurrentValueSubject<[Exercise], Never>([])
    private var cancellables: Set<AnyCancellable> = []

    public init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
        setupBindings()
        coreDataService.context.refreshAllObjects()
    }

    public func fetchExercises() {
        let request = CDExercise.fetchRequest()
        do {
            let exercises = try coreDataService.context.fetch(request)
            exercisesSubject.send(exercises.compactMap(\.coreModel))
        } catch {
            exercisesErrorPublisher.send(.storageError(.readFailed))
        }
    }

    public func delete(with id: String) {
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
        NotificationCenter.default.eventChangedPublisher
            .combineLatest(NotificationCenter.default.coreDataDidSaveObjectIDsPublisher)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchExercises()
            }
            .store(in: &cancellables)
    }
}

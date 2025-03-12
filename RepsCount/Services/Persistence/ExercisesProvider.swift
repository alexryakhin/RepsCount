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
    private let locationManager: LocationManagerInterface
    private let exercisesSubject = CurrentValueSubject<[Exercise], Never>([])
    private var cancellables: Set<AnyCancellable> = []

    public init(
        coreDataService: CoreDataServiceInterface,
        locationManager: LocationManagerInterface
    ) {
        self.coreDataService = coreDataService
        self.locationManager = locationManager
        setupBindings()
        fetchExercises()
    }

    public func fetchExercises() {
        let request = NSFetchRequest<CDExercise>(entityName: "Exercise")
        do {
            let exercises = try coreDataService.context.fetch(request)
            exercisesSubject.send(exercises.compactMap(\.coreModel))
        } catch {
            exercisesErrorPublisher.send(.storageError(.readFailed))
        }
    }

    public func delete(with id: String) {
        let fetchRequest: NSFetchRequest<CDExercise> = CDExercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            if let object = try coreDataService.context.fetch(fetchRequest).first {
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
        // every time core data gets updated, call fetchExercises()
        NotificationCenter.default.mergeChangesObjectIDsPublisher
            .combineLatest(NotificationCenter.default.coreDataDidSavePublisher)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetchExercises()
            }
            .store(in: &cancellables)


        NotificationCenter.default.eventChangedPublisher
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetchExercises()
            }
            .store(in: &cancellables)
    }
}

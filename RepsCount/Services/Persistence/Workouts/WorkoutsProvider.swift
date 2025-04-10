//
//  WorkoutsProvider.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on January 6, 2025.
//

import CoreData
import Combine
import Core

public protocol WorkoutsProviderInterface {
    var workoutsPublisher: AnyPublisher<[WorkoutInstance], Never> { get }
    var errorPublisher: PassthroughSubject<CoreError, Never> { get }

    func delete(with id: String)
    func fetchWorkouts()
}

public final class WorkoutsProvider: WorkoutsProviderInterface {

    public var workoutsPublisher: AnyPublisher<[WorkoutInstance], Never> {
        return workoutsSubject.eraseToAnyPublisher()
    }

    public let errorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface
    private let workoutsSubject = CurrentValueSubject<[WorkoutInstance], Never>([])
    private var cancellables: Set<AnyCancellable> = []

    public init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
        setupBindings()
        fetchWorkouts()
    }

    public func fetchWorkouts() {
        let request = CDWorkoutInstance.fetchRequest()
        do {
            let workouts = try coreDataService.context.fetch(request)
            workoutsSubject.send(workouts.compactMap(\.coreModel))
        } catch {
            errorPublisher.send(.storageError(.readFailed))
        }
    }

    public func delete(with id: String) {
        let request = CDWorkoutInstance.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            if let object = try coreDataService.context.fetch(request).first {
                object._exercises.forEach { exercise in
                    coreDataService.context.delete(exercise)
                }
                coreDataService.context.delete(object)
                try coreDataService.saveContext()
            } else {
                throw CoreError.internalError(.removingWorkoutFailed)
            }
        } catch {
            errorPublisher.send(.internalError(.removingWorkoutFailed))
        }
    }

    private func setupBindings() {
        coreDataService.dataUpdatedPublisher
            .sink { [weak self] _ in
                self?.fetchWorkouts()
            }
            .store(in: &cancellables)
    }
}

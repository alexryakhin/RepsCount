//
//  WorkoutTemplatesProvider.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on January 6, 2025.
//

import CoreData
import Combine
import Core

public protocol WorkoutTemplatesProviderInterface {
    var templatesPublisher: AnyPublisher<[WorkoutTemplate], Never> { get }
    var templatesErrorPublisher: PassthroughSubject<CoreError, Never> { get }

    func delete(with id: String)
    func fetchTemplates()
}

public final class WorkoutTemplatesProvider: WorkoutTemplatesProviderInterface {

    public var templatesPublisher: AnyPublisher<[WorkoutTemplate], Never> {
        return templatesSubject.eraseToAnyPublisher()
    }

    public let templatesErrorPublisher = PassthroughSubject<CoreError, Never>()

    private let coreDataService: CoreDataServiceInterface
    private let templatesSubject = CurrentValueSubject<[WorkoutTemplate], Never>([])
    private var cancellables: Set<AnyCancellable> = []

    public init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
        setupBindings()
        fetchTemplates()
    }

    public func fetchTemplates() {
        let request = CDWorkoutTemplate.fetchRequest()
        do {
            let templates = try coreDataService.context.fetch(request)
            templatesSubject.send(templates.compactMap(\.coreModel))
        } catch {
            templatesErrorPublisher.send(.storageError(.readFailed))
        }
    }

    public func delete(with id: String) {
        let request = CDWorkoutTemplate.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            if let object = try coreDataService.context.fetch(request).first {
                coreDataService.context.delete(object)
                try coreDataService.saveContext()
            } else {
                throw CoreError.internalError(.removingTemplateFailed)
            }
        } catch {
            templatesErrorPublisher.send(.internalError(.removingTemplateFailed))
        }
    }

    private func setupBindings() {
        coreDataService.dataUpdatedPublisher
            .sink { [weak self] _ in
                self?.fetchTemplates()
            }
            .store(in: &cancellables)
    }
}

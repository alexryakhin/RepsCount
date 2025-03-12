//
//  ExercisesListViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Core
import CoreUserInterface
import CoreNavigation
import Services
import Combine
import UIKit

public class ExercisesListViewModel: DefaultPageViewModel {    

    enum Input {
        case showAddExercise
        case showExerciseDetails(Exercise)
        case selectNameFilter(String?)
        case deleteElements(indices: IndexSet, date: Date)
    }

    enum Output {
        case showAddExercise
        case showExerciseDetails(Exercise)
    }

    var onOutput: ((Output) -> Void)?

    @Published private(set) var sections: [ExercisesListContentView.ListSection] = []
    @Published private(set) var sortedUniqueExerciseNames: [String] = []
    @Published private(set) var selectedNameFilter: String? = nil
    @Published var selectedDate: Date?

    private let exercisesProvider: ExercisesProviderInterface
    private var cancellables: Set<AnyCancellable> = []

    public init(
        exercisesProvider: ExercisesProviderInterface
    ) {
        self.exercisesProvider = exercisesProvider
        super.init()
        loadingStarted()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .showAddExercise:
            onOutput?(.showAddExercise)
        case .showExerciseDetails(let exercise):
            onOutput?(.showExerciseDetails(exercise))
        case .selectNameFilter(let nameFilter):
            selectedNameFilter = nameFilter
        case .deleteElements(let indices, let date):
            deleteElements(at: indices, for: date)
        }
    }

    private func deleteElements(at indices: IndexSet, for date: Date) {
        if let exercises = sections.first(where: { $0.date == date })?.items {
            indices.map { exercises[$0] }
                .forEach { [weak self] in
                    self?.deleteExercise($0.id)
                }
        }
    }

    private func deleteExercise(_ id: String) {
        exercisesProvider.delete(with: id)
    }

    private func setupBindings() {
        exercisesProvider.exercisesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] exercises in
                if exercises.isNotEmpty {
                    self?.prepareExercisesForDisplay(exercises)
                    self?.resetAdditionalState()
                } else {
                    self?.additionalState = .placeholder()
                }
            }
            .store(in: &cancellables)
    }

    private func prepareExercisesForDisplay(_ exercises: [Exercise]) {
        Task { [weak self] in
            let groupedExercises = Dictionary(grouping: exercises, by: { exercise in
                exercise.timestamp.startOfDay
            })
                .sorted(by: { $0.key > $1.key })
                .map { key, value in
                    ExercisesListContentView.ListSection(
                        date: key,
                        title: key.formatted(date: .complete, time: .omitted),
                        items: value
                    )
                }

            let names = Dictionary(grouping: exercises, by: { $0.name })
                .mapValues { $0.count }
                .sorted {
                    if $0.value == $1.value {
                        return $0.key < $1.key // Secondary sorting by name (alphabetical)
                    }
                    return $0.value > $1.value // Primary sorting by count (descending)
                }
                .compactMap { $0.key }

            await MainActor.run { [weak self, groupedExercises, names] in
                self?.sections = groupedExercises
                self?.sortedUniqueExerciseNames = names
            }
        }
    }
}

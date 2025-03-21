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
import SwiftUI

public class ExercisesListViewModel: DefaultPageViewModel {

    @AppStorage(UDKeys.savesLocation) var savesLocation: Bool = true

    enum Input {
        case showExerciseDetails(Exercise)
        case deleteExercise(Exercise)
    }

    enum Output {
        case showExerciseDetails(Exercise)
    }

    var onOutput: ((Output) -> Void)?

    @Published private(set) var sections: [ExercisesListContentView.ListSection] = []
    @Published var selectedDate: Date? {
        didSet {
            HapticManager.shared.triggerSelection()
        }
    }

    private let locationManager: LocationManagerInterface
    private let exercisesProvider: ExercisesProviderInterface
    private var cancellables: Set<AnyCancellable> = []

    public init(
        locationManager: LocationManagerInterface,
        exercisesProvider: ExercisesProviderInterface
    ) {
        self.locationManager = locationManager
        self.exercisesProvider = exercisesProvider
        super.init()
        loadingStarted()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .showExerciseDetails(let exercise):
            onOutput?(.showExerciseDetails(exercise))
        case .deleteExercise(let exercise):
            deleteExercise(exercise.id)
        }
    }

    private func deleteExercise(_ id: String) {
        exercisesProvider.delete(with: id)
    }

    private func setupBindings() {
        exercisesProvider.exercisesPublisher
            .removeDuplicates()
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

            await MainActor.run { [weak self, groupedExercises] in
                self?.sections = groupedExercises
            }
        }
    }
}

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

public class ExercisesListViewModel: DefaultPageViewModel {

    enum Input {
        case showAddExercise
    }

    enum Output {
        case showAddExercise
    }

    var onOutput: ((Output) -> Void)?

    public init(
        arg: Int
    ) {
        super.init()
        loadingStarted()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .showAddExercise:
            onOutput?(.showAddExercise)
        }
    }

    private func setupBindings() {
    }
}

//
//  ViewController.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import UIKit
import SwiftUI

final class ExercisesListViewController: PageViewController<ExercisesListContentView>, NavigationBarVisible {

    enum Event {
        case showExerciseDetails(Exercise)
    }

    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: ExercisesListViewModel

    // MARK: - Initialization

    init(viewModel: ExercisesListViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ExercisesListContentView(viewModel: viewModel))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        setupBindings()
        navigationItem.title = NSLocalizedString("Exercises", comment: .empty)
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .showExerciseDetails(let exercise):
                self?.onEvent?(.showExerciseDetails(exercise))
            }
        }
    }
}

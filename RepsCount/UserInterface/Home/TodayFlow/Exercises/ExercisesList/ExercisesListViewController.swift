//
//  ViewController.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import UIKit
import SwiftUI
import CoreUserInterface
import Core

public final class ExercisesListViewController: PageViewController<ExercisesListContentView>, NavigationBarVisible {

    public enum Event {
        case showExerciseDetails(Exercise)
    }

    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties

    private let viewModel: ExercisesListViewModel

    // MARK: - Initialization

    public init(viewModel: ExercisesListViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ExercisesListContentView(viewModel: viewModel))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        setupBindings()
        navigationItem.title = "Exercises"
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

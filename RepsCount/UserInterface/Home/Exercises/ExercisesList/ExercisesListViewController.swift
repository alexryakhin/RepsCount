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
        case showAddExercise
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

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override public func setup() {
        super.setup()
        setupBindings()
        tabBarItem = TabBarItem.exercises.item
    }

    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = TabBarItem.exercises.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .showAddExercise:
                self?.onEvent?(.showAddExercise)
            case .showExerciseDetails(let exercise):
                self?.onEvent?(.showExerciseDetails(exercise))
            }
        }
    }
}

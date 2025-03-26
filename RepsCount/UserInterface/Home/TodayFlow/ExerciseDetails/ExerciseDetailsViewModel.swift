import Core
import CoreUserInterface
import Services
import Shared
import Combine
import SwiftUI

public final class ExerciseDetailsViewModel: DefaultPageViewModel {

    @AppStorage(UDKeys.measurementUnit) var measurementUnit: MeasurementUnit = .kilograms

    @Published var exercise: Exercise
    @Published var amountInput = ""
    @Published var weightInput = ""

    var isEditable: Bool {
        Calendar.current.isDateInToday(exercise.timestamp)
    }

    var totalAmount: Double {
        exercise.sets.map { $0.amount }.reduce(0, +)
    }

    enum Input {
        case addSet
        case deleteSet(ExerciseSet)
        case updateNotes
        case deleteExercise
    }

    enum Output {
        case finish
    }

    var onOutput: ((Output) -> Void)?

    // MARK: - Private Properties

    private let exerciseDetailsManager: ExerciseDetailsManagerInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        exercise: Exercise,
        exerciseDetailsManager: ExerciseDetailsManagerInterface
    ) {
        self.exercise = exercise
        self.exerciseDetailsManager = exerciseDetailsManager
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .addSet:
            addSet()
        case .deleteSet(let set):
            deleteSet(set)
        case .updateNotes:
            exerciseDetailsManager.updateNotes(exercise.notes)
        case .deleteExercise:
            showAlert(
                withModel: .init(
                    title: "Delete exercise",
                    message: "Are you sure you want to delete this exercise?",
                    actionText: "Cancel",
                    destructiveActionText: "Delete",
                    action: {
                        AnalyticsService.shared.logEvent(.exerciseDetailsExerciseRemoveCancelButtonTapped)
                    },
                    destructiveAction: { [weak self] in
                        self?.exerciseDetailsManager.deleteExercise()
                        self?.onOutput?(.finish)
                        AnalyticsService.shared.logEvent(.exerciseDetailsExerciseRemoveButtonTapped)
                    }
                )
            )
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        exerciseDetailsManager.exercisePublisher
            .ifNotNil()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exercise in
                self?.exercise = exercise
            }
            .store(in: &cancellables)

        exerciseDetailsManager.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorReceived(error, displayType: .alert)
            }
            .store(in: &cancellables)
    }

    private func addSet() {
        defer {
            amountInput = ""
            weightInput = ""
        }
        guard let amount = Double(amountInput) else { return }
        let kilograms = measurementUnit.convertToKilograms(Double(weightInput) ?? .zero).value
        exerciseDetailsManager.addSet(amount, weight: kilograms)
    }

    private func deleteSet(_ set: ExerciseSet) {
        exerciseDetailsManager.deleteSet(set)
    }
}

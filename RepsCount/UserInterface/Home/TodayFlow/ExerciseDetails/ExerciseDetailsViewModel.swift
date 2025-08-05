import Combine
import SwiftUI

final class ExerciseDetailsViewModel: BaseViewModel {

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
        case updateDefaults(amount: Double, sets: Double)
        case deleteExercise
    }

    enum Output {
        case finish
    }

    let output = PassthroughSubject<Output, Never>()

    // MARK: - Private Properties

    private let exerciseDetailsManager: ExerciseDetailsManagerInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(exercise: Exercise) {
        self.exercise = exercise
        self.exerciseDetailsManager = ServiceManager.shared.createExerciseDetailsManager(exerciseID: exercise.id)
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
        case .updateDefaults(let amount, let sets):
            exerciseDetailsManager.updateDefaults(amount, sets: sets)
        case .deleteExercise:
            showAlert(
                withModel: .init(
                    title: Loc.ExerciseDetails.deleteExercise.localized,
                    message: Loc.ExerciseDetails.deleteExerciseMessage.localized,
                    actionText: Loc.Common.cancel.localized,
                    destructiveActionText: Loc.Common.delete.localized,
                    action: {
                        AnalyticsService.shared.logEvent(.exerciseDetailsExerciseRemoveCancelButtonTapped)
                    },
                    destructiveAction: { [weak self] in
                        self?.exerciseDetailsManager.deleteExercise()
                        self?.output.send(.finish)
                        AnalyticsService.shared.logEvent(.exerciseDetailsExerciseRemoveButtonTapped)
                    }
                )
            )
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        exerciseDetailsManager.exercisePublisher
            .compactMap { $0 }
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exercise in
                self?.exercise = exercise
            }
            .store(in: &cancellables)

        exerciseDetailsManager.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showError(error)
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

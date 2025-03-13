import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine
import SwiftUI

public final class ExerciseDetailsViewModel: DefaultPageViewModel {

    @AppStorage(UDKeys.measurementUnit) var measurementUnit: MeasurementUnit = .kilograms

    @Published private(set) var exercise: Exercise

    @Published var amountInput = ""
    @Published var weightInput = ""
    @Published var notesInput = ""

    var isEditable: Bool {
        Calendar.current.isDateInToday(exercise.timestamp)
    }

    var totalAmount: Double {
        exercise.sets.map { $0.amount }.reduce(0, +)
    }

    enum Input {
        case addSet
        case deleteSet(at: IndexSet)
    }

    enum Output {
        // Output actions to pass to the view controller
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
        case .deleteSet(let indexSet):
            deleteSet(at: indexSet)
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        exerciseDetailsManager.exercisePublisher
            .ifNotNil()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exercise in
                self?.exercise = exercise
                self?.notesInput = exercise.notes.orEmpty
            }
            .store(in: &cancellables)

        exerciseDetailsManager.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorReceived(error, displayType: .alert)
            }
            .store(in: &cancellables)

        $notesInput
            .removeDuplicates()
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.exerciseDetailsManager.updateNotes(text)
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

    private func deleteSet(at offsets: IndexSet) {
        exerciseDetailsManager.deleteSet(atOffsets: offsets)
    }
}

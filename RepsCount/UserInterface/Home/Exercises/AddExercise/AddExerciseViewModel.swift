import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine
import SwiftUI

public final class AddExerciseViewModel: DefaultPageViewModel {

    @AppStorage(UDKeys.savesLocation) var savesLocation: Bool = true

    enum Input {
        case addExercise
    }

    enum Output {
        // Output actions to pass to the view controller
    }

    var onOutput: ((Output) -> Void)?

    @Published var selectedType: ExerciseType?
    @Published var selectedCategory: ExerciseCategory?
    @Published var selectedExercise: ExerciseModel?

    // MARK: - Private Properties

    private let addExerciseManager: AddExerciseManagerInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        addExerciseManager: AddExerciseManagerInterface
    ) {
        self.addExerciseManager = addExerciseManager
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .addExercise:
            addExercise()
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        // Services and Published properties subscriptions
    }

    private func addExercise() {
        guard let selectedExercise else { return }
        do {
            try addExerciseManager.addExercise(from: selectedExercise, savesLocation: savesLocation)
        } catch {
            errorReceived(error, displayType: .alert)
        }
    }
}

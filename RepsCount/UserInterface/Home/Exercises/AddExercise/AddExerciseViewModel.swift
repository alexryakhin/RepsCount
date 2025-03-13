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
    @Published var selectedExercise: String?

    // MARK: - Private Properties

    private let addExerciseManager: AddExerciseManagerInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(addExerciseManager: AddExerciseManagerInterface) {
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
        guard let selectedExerciseModel else {
            // Handle invalid input (e.g., show an error message to the user)
            return
        }

        try? addExerciseManager.addExercise(from: selectedExerciseModel, savesLocation: savesLocation)
    }
}

extension AddExerciseViewModel {
    var exercises: [String] {
        guard let selectedType, let selectedCategory else { return [] }
        return ExerciseModel.presets.filter { preset in
            preset.type == selectedType
            && preset.category == selectedCategory
        }
        .map(\.name)
    }

    var selectedExerciseModel: ExerciseModel? {
        ExerciseModel.presets.first { model in
            model.type == selectedType
            && model.category == selectedCategory
            && model.name == selectedExercise
        }
    }
}

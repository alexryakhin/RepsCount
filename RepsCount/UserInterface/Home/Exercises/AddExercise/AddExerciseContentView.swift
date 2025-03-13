import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core

public struct AddExerciseContentView: PageView {

    @Environment(\.dismiss) var dismiss

    public typealias ViewModel = AddExerciseViewModel

    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: AddExerciseViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        NavigationView {
            List {
                ListFlowPicker(
                    selection: $viewModel.selectedType,
                    items: ExerciseType.allCases,
                    header: "Type"
                )
                if let selectedType = viewModel.selectedType {
                    ListFlowPicker(
                        selection: $viewModel.selectedCategory,
                        items: selectedType.categories,
                        header: "Category"
                    )
                    .transition(.opacity)
                }
                if let selectedCategory = viewModel.selectedCategory {
                    ListFlowPicker(
                        selection: $viewModel.selectedExercise,
                        items: selectedCategory.exercises,
                        header: "Exercise"
                    )
                    .transition(.opacity)
                }
            }
            .animation(.default, value: viewModel.selectedCategory == nil)
            .animation(.default, value: viewModel.selectedType == nil)
            .animation(.default, value: viewModel.selectedExercise == nil)
            .navigationTitle("Choose an exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    Button {
                        viewModel.handle(.addExercise)
                        dismiss()
                        HapticManager.shared.triggerNotification(type: .success)
                    } label: {
                        Text("Choose")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.selectedExercise == nil)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
        }
    }
}

extension ExerciseType: @retroactive Selectable {
    public var name: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
}

extension ExerciseCategory: @retroactive Selectable {
    public var name: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
}

extension ExerciseModel: @retroactive Selectable {
    public var name: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
}

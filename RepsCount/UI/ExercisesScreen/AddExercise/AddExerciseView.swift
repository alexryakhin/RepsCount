//
//  AddExerciseView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/25/24.
//

import SwiftUI

struct AddExerciseView: ViewWithBackground {

    struct Config {
        let isPresented: Binding<Bool>
        let onGoToAddExerciseModel: () -> Void
    }

    @AppStorage("savesLocation") var savesLocation: Bool = true
    @ObservedObject private var viewModel: AddExerciseViewModel
    @State private var isAddingNewExercise = false

    private let config: Config

    private var exerciseTypes: [String] {
        viewModel.exerciseTypes.keys.sorted()
    }

    private var exerciseCategories: [String] {
        guard let selectedType = viewModel.selectedType,
              let categories = viewModel.exerciseTypes[selectedType] else {
            return []
        }
        return categories.keys.sorted()
    }

    private var exercises: [String] {
        guard let selectedType = viewModel.selectedType,
              let selectedCategory = viewModel.selectedCategory,
              let categories = viewModel.exerciseTypes[selectedType],
              let exercises = categories[selectedCategory] else {
            return []
        }
        return exercises.sorted()
    }

    init(
        viewModel: AddExerciseViewModel,
        config: Config
    ) {
        self.viewModel = viewModel
        self.config = config
    }

    var content: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    FlowPicker(
                        selection: $viewModel.selectedType,
                        items: exerciseTypes,
                        header: "Type"
                    )
                    if exerciseCategories.isEmpty == false {
                        FlowPicker(
                            selection: $viewModel.selectedCategory,
                            items: exerciseCategories,
                            header: "Category"
                        )
                    }
                    if exercises.isEmpty == false {
                        FlowPicker(
                            selection: $viewModel.selectedExercise,
                            items: exercises,
                            header: "Exercise"
                        )
                    }
                }
                .padding(.horizontal, 16)
            }
            .background(Color.background)
            .navigationTitle("Choose an exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        config.isPresented.wrappedValue = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    Button {
                        viewModel.addExercise(savesLocation: savesLocation)
                        config.isPresented.wrappedValue = false
                        HapticManager.shared.triggerNotification(type: .success)
                    } label: {
                        Text("Choose")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.findExerciseModel() == nil)
                    // TODO: add later
    //                Button {
    //                    config.onGoToAddExerciseModel()
    //                } label: {
    //                    Text("Didn't find exercise?")
    //                        .bold()
    //                        .frame(maxWidth: .infinity)
    //                        .padding(12)
    //                        .cornerRadius(12)
    //                }
    //                .buttonStyle(.bordered)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    DIContainer.shared.resolver.resolve(AddExerciseView.self)!
}

extension View {
    func clippedWithBackground(_ color: Color = .surface) -> some View {
        self
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

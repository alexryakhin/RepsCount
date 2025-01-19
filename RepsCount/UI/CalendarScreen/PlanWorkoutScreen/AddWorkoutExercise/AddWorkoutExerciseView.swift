//
//  AddWorkoutExerciseView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/25/24.
//

import SwiftUI
import CoreData

struct AddWorkoutExerciseView: ViewWithBackground {

    struct Config {
        let isPresented: Binding<Bool>
        let onSelectExerciseModel: (ExerciseModel) -> Void
        let onGoToAddExerciseModel: () -> Void
    }

    @ObservedObject private var viewModel: AddWorkoutExerciseViewModel

    private let config: Config

    private var exerciseTypes: [String] {
        viewModel.exerciseTypes.keys.sorted()
    }

    private var exerciseCategories: [String] {
        guard let categories = viewModel.exerciseTypes[viewModel.selectedType] else {
            return []
        }
        return categories.keys.sorted()
    }

    private var exercises: [String] {
        guard let categories = viewModel.exerciseTypes[viewModel.selectedType],
              let exercises = categories[viewModel.selectedCategory] else {
            return []
        }
        return exercises.sorted()
    }

    init(
        viewModel: AddWorkoutExerciseViewModel,
        config: Config
    ) {
        self.viewModel = viewModel
        self.config = config
    }

    var content: some View {
        ScrollView {
            VStack {
                Text("Choose an exercise")
                    .fontWeight(.bold)
                    .font(.system(.title))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
                Spacer()
                VStack(spacing: 8) {
                    HStack {
                        Text("Type")
                            .fontWeight(.semibold)
                            .font(.system(.headline))
                        Spacer()
                        Picker("Select type", selection: $viewModel.selectedType) {
                            ForEach(exerciseTypes, id: \.self) { type in
                                Text(LocalizedStringKey(type)).tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .buttonStyle(.bordered)
                    }

                    HStack {
                        Text("Category")
                            .fontWeight(.semibold)
                            .font(.system(.headline))
                        Spacer()
                        Picker("Select category", selection: $viewModel.selectedCategory) {
                            ForEach(exerciseCategories, id: \.self) { category in
                                Text(LocalizedStringKey(category)).tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .buttonStyle(.bordered)
                    }

                    HStack {
                        Text("Exercise")
                            .fontWeight(.semibold)
                            .font(.system(.headline))
                        Spacer()
                        Picker("Select exercise", selection: $viewModel.selectedExercise) {
                            ForEach(exercises, id: \.self) { exercise in
                                Text(LocalizedStringKey(exercise)).tag(exercise)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .buttonStyle(.bordered)
                    }
                }
                .padding(.vertical)
            }
            .padding(16)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                Button {
                    if let model = viewModel.findExerciseModel() {
                        config.onSelectExerciseModel(model)
                    }
                } label: {
                    Text("Select")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .cornerRadius(12)
                }
                .buttonStyle(.borderedProminent)
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

#Preview {
    DIContainer.shared.resolver.resolve(AddWorkoutExerciseView.self)!
}

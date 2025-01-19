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
        viewModel: AddExerciseViewModel,
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
                        if isAddingNewExercise {
                            TextField("Enter exercise name", text: $viewModel.text)
                                .padding(6)
                                .background(Color(uiColor: UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(radius: 2, x: 0, y: 4)
                        } else {
                            Picker("Select exercise", selection: $viewModel.selectedExercise) {
                                ForEach(exercises, id: \.self) { exercise in
                                    Text(LocalizedStringKey(exercise)).tag(exercise)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .buttonStyle(.bordered)
                        }
                    }
                }
                .padding(.vertical)
            }
            .padding(16)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                Button {
                    viewModel.addExercise(savesLocation: savesLocation)
                    config.isPresented.wrappedValue = false
                } label: {
                    Text("Choose")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .cornerRadius(12)
                }
                .buttonStyle(.borderedProminent)
                Button {
                    config.onGoToAddExerciseModel()
                } label: {
                    Text("Didn't find exercise?")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .cornerRadius(12)
                }
                .buttonStyle(.bordered)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    DIContainer.shared.resolver.resolve(AddExerciseView.self)!
}

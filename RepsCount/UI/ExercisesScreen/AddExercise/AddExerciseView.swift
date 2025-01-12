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
        Array(viewModel.exerciseTypes.keys)
    }

    private var exerciseCategories: [String] {
        guard let categories = viewModel.exerciseTypes[viewModel.selectedType] else {
            return []
        }
        return Array(categories.keys)
    }

    private var exercises: [String] {
        guard let categories = viewModel.exerciseTypes[viewModel.selectedType],
              let exercises = categories[viewModel.selectedCategory] else {
            return []
        }
        return exercises
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
                VStack(spacing: 16) {
                    HStack {
                        Text("Type")
                            .fontWeight(.semibold)
                            .font(.system(.headline))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Picker("Select type", selection: $viewModel.selectedType) {
                            ForEach(exerciseTypes, id: \.self) { type in
                                Text(LocalizedStringKey(type)).tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(6)
                        .background(Color(uiColor: UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 2, x: 0, y: 4)
                    }

                    HStack {
                        Text("Category")
                            .fontWeight(.semibold)
                            .font(.system(.headline))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Picker("Select category", selection: $viewModel.selectedCategory) {
                            ForEach(exerciseCategories, id: \.self) { category in
                                Text(LocalizedStringKey(category)).tag(category)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(6)
                        .background(Color(uiColor: UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 2, x: 0, y: 4)
                    }

                    HStack {
                        Text("Exercise")
                            .fontWeight(.semibold)
                            .font(.system(.headline))
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                            .padding(6)
                            .background(Color(uiColor: UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 2, x: 0, y: 4)
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
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                Button {
                    config.onGoToAddExerciseModel()
                } label: {
                    Text("Didn't find exercise?")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    DIContainer.shared.resolver.resolve(AddExerciseView.self)!
}

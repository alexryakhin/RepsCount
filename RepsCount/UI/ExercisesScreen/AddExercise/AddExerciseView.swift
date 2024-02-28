//
//  AddExerciseView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/25/24.
//

import SwiftUI

struct AddExerciseView: ViewWithBackground {
    @AppStorage("savesLocation") var savesLocation: Bool = true
    @StateObject private var viewModel = AddExerciseViewModel()
    @Binding var isPresented: Bool
    @State private var isAddingNewExercise = false

    private var exerciseCategories: [String] {
        viewModel.exerciseCategories.keys.sorted()
    }

    private var exercises: [String] {
        viewModel.exerciseCategories[viewModel.selectedCategory] ?? []
    }

    var content: some View {
        VStack {
            Text("Choose an exercise")
                .font(.system(.title, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            Spacer()
            VStack {
                HStack {
                    Text("Category")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(.headline, weight: .semibold))
                    Picker(selection: $viewModel.selectedCategory) {
                        ForEach(exerciseCategories, id: \.self) { category in
                            Text(LocalizedStringKey(category))
                        }
                    } label: {
                        Text("Select a category")
                    }
                    .labelsHidden()
                    .padding(6)
                    .background(Color(uiColor: UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 2, x: 0, y: 4)

                }

                HStack {
                    Text("Exercise")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(.headline, weight: .semibold))
                    if isAddingNewExercise {
                        TextField("Enter exercise name", text: $viewModel.text)
                            .padding(6)
                            .padding(.leading, 6)
                            .padding(.vertical, 6)
                            .background(Color(uiColor: UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 2, x: 0, y: 4)
                    } else {
                        Picker(selection: $viewModel.selectedExercise) {
                            ForEach(exercises, id: \.self) { exercise in
                                Text(LocalizedStringKey(exercise))
                            }
                        } label: {
                            Text("Select an exercise")
                        }
                        .labelsHidden()
                        .padding(6)
                        .background(Color(uiColor: UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 2, x: 0, y: 4)
                    }
                }
            }
            .padding(.vertical)

            Spacer()
            Button {
//                if isAddingNewExercise {
//                    // add action
//                } else {
                    // save action
                viewModel.addExercise(savesLocation: savesLocation)
                isPresented = false
//                }
            } label: {
                Text(isAddingNewExercise ? "Add" : "Choose")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

//            Button("Or add a new exercise to the list") {
//                withAnimation {
//                    isAddingNewExercise = true
//                }
//            }
//            .font(.system(.subheadline, weight: .medium))
//            .padding()
        }
        .padding(16)
    }
}

#Preview {
    AddExerciseView(isPresented: .constant(true))
}


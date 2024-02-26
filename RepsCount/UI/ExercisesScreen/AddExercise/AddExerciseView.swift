//
//  AddExerciseView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/25/24.
//

import SwiftUI

struct AddExerciseView: ViewWithBackground {

    @State var exerciseCategories: [String: [String]]

    @State private var text = ""
    @State private var selectedGroup = "Arms"
    @State private var selectedExercise = ""

    @State private var isAddingNewExercise = false

    init() {
        _exerciseCategories = State(initialValue: defaultExerciseCategories)
    }

    var content: some View {
        VStack {
            Text("Choose an exercise")
                .font(.system(.title, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            VStack {
                HStack {
                    Text("Category")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(.headline, weight: .semibold))
                    Picker(selection: $selectedGroup) {
                        ForEach(Array(exerciseCategories.keys.sorted()), id: \.self) { key in
                            Text(key)
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
                        TextField("Enter exercise name", text: $text)
                            .padding(6)
                            .padding(.leading, 6)
                            .padding(.vertical, 6)
                            .background(Color(uiColor: UIColor.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 2, x: 0, y: 4)

                    } else {
                        Picker(selection: $selectedExercise) {
                            ForEach(Array(exerciseCategories[selectedGroup]?.sorted() ?? []), id: \.self) { exercise in
                                Text(exercise)
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
            .onAppear {
                if let firstExercise = exerciseCategories[selectedGroup]?.first {
                    selectedExercise = firstExercise
                }
            }

            Button {

                if isAddingNewExercise {
                    // add action
                    exerciseCategories[selectedGroup]?.append(text.capitalized)
                    selectedExercise = text.capitalized
                    text = ""
                    isAddingNewExercise = false
                } else {
                    // save action
                }
            } label: {
                Text(isAddingNewExercise ? "Add" : "Choose")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Button("Or add a new exercise to the list") {
                withAnimation {
                    isAddingNewExercise = true
                }
            }
            .font(.system(.subheadline, weight: .medium))
            .padding()
        }
        .padding(16)
    }
}

#Preview {
    AddExerciseView()
}

let defaultExerciseCategories: [String: [String]] = [
    "Legs": [
        "Squats",
        "Lunges",
        "Leg Press",
        "Deadlifts",
        "Leg Curls",
        "Calf Raises"
        // ... add more leg exercises
    ],
    "Core": [
        "Crunches",
        "Russian Twist",
        "Leg Raises",
        "Oblique Twist",
        "Superman"
        // ... add more core exercises
    ],
    "Arms": [
        "Bicep Curls",
        "Tricep Dips",
        "Hammer Curls",
        "Tricep Extension",
        "Push-ups",
        "Pull-ups"
        // ... add more arm exercises
    ],
    "Chest": [
        "Bench Press",
        "Push-ups",
        "Dumbbell Flyes",
        "Chest Press",
        "Cable Crossover",
        "Incline Bench Press"
        // ... add more chest exercises
    ],
    "Back": [
        "Pull-ups",
        "Barbell Rows",
        "Dumbbell Rows",
        "Deadlifts",
        "Lat Pulldowns",
        "T-Bar Rows",
        "Face Pulls"
        // ... add more back exercises
    ],
    "Shoulders": [
        "Shoulder Press",
        "Lateral Raises",
        "Front Raises",
        "Shrugs",
        "Upright Rows",
        "Face Pulls"
        // ... add more shoulder exercises
    ]
    // ... add more categories if needed
]

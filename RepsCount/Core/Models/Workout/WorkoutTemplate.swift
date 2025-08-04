//
//  WorkoutTemplate.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

struct WorkoutTemplate: Identifiable, Hashable {
    let id: String
    let name: String
    let notes: String?
    let templateExercises: [WorkoutTemplateExercise]
    let workoutInstanceIds: [String]
    let workoutEventIds: [String]

    init(
        id: String,
        name: String,
        notes: String?,
        templateExercises: [WorkoutTemplateExercise],
        workoutInstanceIds: [String],
        workoutEventIds: [String]
    ) {
        self.id = id
        self.name = name
        self.notes = notes
        self.templateExercises = templateExercises
        self.workoutInstanceIds = workoutInstanceIds
        self.workoutEventIds = workoutEventIds
    }
}

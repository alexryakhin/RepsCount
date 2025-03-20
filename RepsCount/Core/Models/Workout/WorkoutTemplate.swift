//
//  WorkoutTemplate.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

public struct WorkoutTemplate: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let notes: String?
    public let templateExercises: [WorkoutTemplateExercise]
    public let workoutInstanceIds: [String]
    public let workoutEventIds: [String]

    public init(
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

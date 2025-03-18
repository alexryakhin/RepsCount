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
    public let workoutInstances: [WorkoutInstance]
    public let workoutEventId: String?

    public init(
        id: String,
        name: String,
        notes: String?,
        templateExercises: [WorkoutTemplateExercise],
        workoutInstances: [WorkoutInstance],
        workoutEventId: String?
    ) {
        self.id = id
        self.name = name
        self.notes = notes
        self.templateExercises = templateExercises
        self.workoutInstances = workoutInstances
        self.workoutEventId = workoutEventId
    }
}

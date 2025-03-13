//
//  ExerciseModel+CoreDataClass.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

public struct ExerciseModel: Identifiable, Hashable {
    public let name: String
    public let category: ExerciseCategory
    public let type: ExerciseType
    public let metricType: ExerciseMetricType
    public let id: String
    public let defaultReps: Int
    public let defaultSets: Int
    public let defaultWeight: Double
    public let notes: String?

    public init(
        name: String,
        category: ExerciseCategory,
        type: ExerciseType,
        metricType: ExerciseMetricType,
        id: String = UUID().uuidString,
        defaultReps: Int = .zero,
        defaultSets: Int = .zero,
        defaultWeight: Double = .zero,
        notes: String? = nil
    ) {
        self.name = name
        self.category = category
        self.type = type
        self.metricType = metricType
        self.id = id
        self.defaultReps = defaultReps
        self.defaultSets = defaultSets
        self.defaultWeight = defaultWeight
        self.notes = notes
    }
}

public extension ExerciseModel {
    static let presets: [ExerciseModel] = [
        // Strength Training - Legs
        .init(name: "Squats", category: .legs, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Lunges", category: .legs, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Leg Press", category: .legs, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Deadlifts", category: .legs, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Leg Curls", category: .legs, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Calf Raises", category: .legs, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Toe Raises", category: .legs, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Split Squat", category: .legs, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Bulgarian Split Squat", category: .legs, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Pistol Squat", category: .legs, type: .strengthTraining, metricType: .weightAndReps),

        // Strength Training - Core
        .init(name: "Crunches", category: .core, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Russian Twist", category: .core, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Leg Raises", category: .core, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Oblique Twist", category: .core, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Superman", category: .core, type: .strengthTraining, metricType: .weightAndReps),

        // Strength Training - Arms
        .init(name: "Bicep Curls", category: .arms, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Tricep Dips", category: .arms, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Hammer Curls", category: .arms, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Tricep Extension", category: .arms, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Push-ups", category: .arms, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Chin-ups", category: .arms, type: .strengthTraining, metricType: .weightAndReps),

        // Strength Training - Chest
        .init(name: "Dips", category: .chest, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Push-ups", category: .chest, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Diamond Push-ups", category: .chest, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Dumbbell Flyes", category: .chest, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Bench Press", category: .chest, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Chest Press", category: .chest, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Cable Crossover", category: .chest, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Incline Bench Press", category: .chest, type: .strengthTraining, metricType: .weightAndReps),

        // Strength Training - Back
        .init(name: "Pull-ups", category: .back, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Chin-ups", category: .back, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Lat Pulldowns", category: .back, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Barbell Rows", category: .back, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Dumbbell Rows", category: .back, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Seated Cable Rows", category: .back, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "T-bar Rows", category: .back, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Deadlifts", category: .back, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Hyperextensions", category: .back, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Face Pulls", category: .back, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Reverse Flyes", category: .back, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "One Arm Pull-up", category: .back, type: .strengthTraining, metricType: .weightAndReps),

        // Strength Training - Shoulders
        .init(name: "Overhead Press", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Arnold Press", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Lateral Raises", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Front Raises", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Rear Delt Flyes", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Upright Rows", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Shrugs", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Push Press", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Handstand Push-ups", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),

        // Calisthenics
        .init(name: "Dead Hang", category: .strengthSkills, type: .calisthenics, metricType: .time),
        .init(name: "Planche", category: .strengthSkills, type: .calisthenics, metricType: .time),
        .init(name: "Front Lever", category: .strengthSkills, type: .calisthenics, metricType: .time),
        .init(name: "Back Lever", category: .strengthSkills, type: .calisthenics, metricType: .time),
        .init(name: "Human Flag", category: .strengthSkills, type: .calisthenics, metricType: .time),
        .init(name: "Muscle-ups", category: .strengthSkills, type: .calisthenics, metricType: .weightAndReps),
        .init(name: "Bridge", category: .mobility, type: .calisthenics, metricType: .time),
        .init(name: "Wall Handstand", category: .mobility, type: .calisthenics, metricType: .time),
        .init(name: "L-sit", category: .mobility, type: .calisthenics, metricType: .time),
        .init(name: "Skin the Cat", category: .mobility, type: .calisthenics, metricType: .time),
        .init(name: "Handstand Hold", category: .balance, type: .calisthenics, metricType: .time),
        .init(name: "Handstand Walk", category: .balance, type: .calisthenics, metricType: .time),
        .init(name: "Elbow Lever", category: .balance, type: .calisthenics, metricType: .time)
    ]
}

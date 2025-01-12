//
//  DefaultExerciseTypes.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/7/25.
//

import Foundation

enum ExerciseCategoryPreset: String {
    case legs = "Legs"
    case core = "Core"
    case arms = "Arms"
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case running = "Running"
    case biking = "Biking"
    case swimming = "Swimming"
    case rowing = "Rowing"
    case strengthSkills = "Strength Skills"
    case mobility = "Mobility"
    case balance = "Balance"
}

enum ExerciseTypePreset: String {
    case strengthTraining = "Strength Training"
    case cardio = "Cardio"
    case calisthenics = "Calisthenics"
}

struct ExerciseModelPreset {
    var name: String
    var category: ExerciseCategoryPreset
    var type: ExerciseTypePreset
    var metricType: ExerciseMetricType

    static let presets: [ExerciseModelPreset] = [
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

        // Strength Training - Shoulders
        .init(name: "Overhead Press", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Arnold Press", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Lateral Raises", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Front Raises", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Rear Delt Flyes", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Upright Rows", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Shrugs", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Push Press", category: .shoulders, type: .strengthTraining, metricType: .weightAndReps),
        .init(name: "Handstand Push-ups", category: .shoulders, type: .calisthenics, metricType: .weightAndReps),

        // Cardio
        .init(name: "5k Run", category: .running, type: .cardio, metricType: .timeOnly),
        .init(name: "10k Run", category: .running, type: .cardio, metricType: .timeOnly),
        .init(name: "Sprints", category: .running, type: .cardio, metricType: .distanceAndTime),
        .init(name: "Intervals", category: .running, type: .cardio, metricType: .distanceAndTime),
        .init(name: "Marathon", category: .running, type: .cardio, metricType: .timeOnly),
        .init(name: "Stationary Bike", category: .biking, type: .cardio, metricType: .distanceAndTime),
        .init(name: "Mountain Biking", category: .biking, type: .cardio, metricType: .distanceAndTime),
        .init(name: "Road Biking", category: .biking, type: .cardio, metricType: .distanceAndTime),
        .init(name: "Cycling Intervals", category: .biking, type: .cardio, metricType: .distanceAndTime),
        .init(name: "Freestyle", category: .swimming, type: .cardio, metricType: .distanceAndTime),
        .init(name: "Breaststroke", category: .swimming, type: .cardio, metricType: .distanceAndTime),
        .init(name: "Backstroke", category: .swimming, type: .cardio, metricType: .distanceAndTime),
        .init(name: "Butterfly", category: .swimming, type: .cardio, metricType: .distanceAndTime),
        .init(name: "Distance Swimming", category: .swimming, type: .cardio, metricType: .distanceAndTime),
        .init(name: "500m Row", category: .rowing, type: .cardio, metricType: .timeOnly),
        .init(name: "1000m Row", category: .rowing, type: .cardio, metricType: .timeOnly),
        .init(name: "Rowing Intervals", category: .rowing, type: .cardio, metricType: .distanceAndTime),
        .init(name: "Endurance Rowing", category: .rowing, type: .cardio, metricType: .distanceAndTime),

        // Calisthenics
        .init(name: "Dead Hang", category: .strengthSkills, type: .calisthenics, metricType: .timeOnly),
        .init(name: "Planche", category: .strengthSkills, type: .calisthenics, metricType: .timeOnly),
        .init(name: "Front Lever", category: .strengthSkills, type: .calisthenics, metricType: .timeOnly),
        .init(name: "Back Lever", category: .strengthSkills, type: .calisthenics, metricType: .timeOnly),
        .init(name: "Human Flag", category: .strengthSkills, type: .calisthenics, metricType: .timeOnly),
        .init(name: "Bridge", category: .mobility, type: .calisthenics, metricType: .timeOnly),
        .init(name: "Wall Handstand", category: .mobility, type: .calisthenics, metricType: .timeOnly),
        .init(name: "L-sit", category: .mobility, type: .calisthenics, metricType: .timeOnly),
        .init(name: "Skin the Cat", category: .mobility, type: .calisthenics, metricType: .timeOnly),
        .init(name: "Handstand Hold", category: .balance, type: .calisthenics, metricType: .timeOnly),
        .init(name: "Handstand Walk", category: .balance, type: .calisthenics, metricType: .timeOnly),
        .init(name: "Elbow Lever", category: .balance, type: .calisthenics, metricType: .timeOnly)
    ]
}

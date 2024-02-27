//
//  GlobalConstants.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/28/24.
//

import Foundation

public enum GlobalConstant {

    public static var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    public static var buildVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

    public static let defaultExerciseCategories: [String: [String]] = [
        "Legs": [
            "Squats",
            "Lunges",
            "Leg Press",
            "Deadlifts",
            "Leg Curls",
            "Calf Raises"
        ],
        "Core": [
            "Crunches",
            "Russian Twist",
            "Leg Raises",
            "Oblique Twist",
            "Superman"
        ],
        "Arms": [
            "Bicep Curls",
            "Tricep Dips",
            "Hammer Curls",
            "Tricep Extension",
            "Push-ups",
            "Pull-ups"
        ],
        "Chest": [
            "Dips",
            "Bench Press",
            "Push-ups",
            "Dumbbell Flyes",
            "Chest Press",
            "Cable Crossover",
            "Incline Bench Press"
        ],
        "Back": [
            "Pull-ups",
            "Barbell Rows",
            "Dumbbell Rows",
            "Deadlifts",
            "Lat Pulldowns",
            "T-Bar Rows",
            "Face Pulls"
        ],
        "Shoulders": [
            "Shoulder Press",
            "Lateral Raises",
            "Front Raises",
            "Shrugs",
            "Upright Rows",
            "Face Pulls"
        ]
    ]
}

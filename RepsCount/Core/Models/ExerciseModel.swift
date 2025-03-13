//
//  ExerciseModel+CoreDataClass.swift
//  Services
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

public enum ExerciseModel: String, CaseIterable, Identifiable {
    case squats = "Squats"
    case lunges = "Lunges"
    case legPress = "Leg Press"
    case deadlifts = "Deadlifts"
    case legCurls = "Leg Curls"
    case calfRaises = "Calf Raises"
    case toeRaises = "Toe Raises"
    case splitSquat = "Split Squat"
    case bulgarianSplitSquat = "Bulgarian Split Squat"
    case pistolSquat = "Pistol Squat"

    case crunches = "Crunches"
    case russianTwist = "Russian Twist"
    case legRaises = "Leg Raises"
    case obliqueTwist = "Oblique Twist"
    case superman = "Superman"

    case bicepCurls = "Bicep Curls"
    case tricepDips = "Tricep Dips"
    case hammerCurls = "Hammer Curls"
    case tricepExtension = "Tricep Extension"
    case chinUps = "Chin-ups"

    case dips = "Dips"
    case pushUps = "Push-ups"
    case diamondPushUps = "Diamond Push-ups"
    case dumbbellFlyes = "Dumbbell Flyes"
    case benchPress = "Bench Press"
    case chestPress = "Chest Press"
    case cableCrossover = "Cable Crossover"
    case inclineBenchPress = "Incline Bench Press"

    case pullUps = "Pull-ups"
    case latPulldowns = "Lat Pulldowns"
    case barbellRows = "Barbell Rows"
    case dumbbellRows = "Dumbbell Rows"
    case seatedCableRows = "Seated Cable Rows"
    case tBarRows = "T-bar Rows"
    case hyperextensions = "Hyperextensions"
    case facePulls = "Face Pulls"
    case reverseFlyes = "Reverse Flyes"
    case oneArmPullUp = "One Arm Pull-up"

    case overheadPress = "Overhead Press"
    case arnoldPress = "Arnold Press"
    case lateralRaises = "Lateral Raises"
    case frontRaises = "Front Raises"
    case rearDeltFlyes = "Rear Delt Flyes"
    case uprightRows = "Upright Rows"
    case shrugs = "Shrugs"
    case pushPress = "Push Press"
    case handstandPushUps = "Handstand Push-ups"

    case deadHang = "Dead Hang"
    case planche = "Planche"
    case frontLever = "Front Lever"
    case backLever = "Back Lever"
    case humanFlag = "Human Flag"
    case muscleUps = "Muscle-ups"

    case bridge = "Bridge"
    case wallHandstand = "Wall Handstand"
    case lSit = "L-sit"
    case skinTheCat = "Skin the Cat"

    case handstandHold = "Handstand Hold"
    case handstandWalk = "Handstand Walk"
    case elbowLever = "Elbow Lever"

    public var id: String { rawValue }

    public var category: ExerciseCategory {
        switch self {
        case .squats, .lunges, .legPress, .deadlifts, .legCurls, .calfRaises, .toeRaises, .splitSquat, .bulgarianSplitSquat, .pistolSquat:
            return .legs
        case .crunches, .russianTwist, .legRaises, .obliqueTwist, .superman:
            return .core
        case .bicepCurls, .tricepDips, .hammerCurls, .tricepExtension, .chinUps:
            return .arms
        case .dips, .pushUps, .diamondPushUps, .dumbbellFlyes, .benchPress, .chestPress, .cableCrossover, .inclineBenchPress:
            return .chest
        case .pullUps, .latPulldowns, .barbellRows, .dumbbellRows, .seatedCableRows, .tBarRows, .hyperextensions, .facePulls, .reverseFlyes, .oneArmPullUp:
            return .back
        case .overheadPress, .arnoldPress, .lateralRaises, .frontRaises, .rearDeltFlyes, .uprightRows, .shrugs, .pushPress, .handstandPushUps:
            return .shoulders
        case .deadHang, .planche, .frontLever, .backLever, .humanFlag, .muscleUps:
            return .strengthSkills
        case .bridge, .wallHandstand, .lSit, .skinTheCat:
            return .mobility
        case .handstandHold, .handstandWalk, .elbowLever:
            return .balance
        }
    }

    public var type: ExerciseType {
        switch self {
        case .deadHang, .planche, .frontLever, .backLever, .humanFlag, .muscleUps, .bridge, .wallHandstand, .lSit, .skinTheCat, .handstandHold, .handstandWalk, .elbowLever:
            return .calisthenics
        default:
            return .strengthTraining
        }
    }

    public var metricType: ExerciseMetricType {
        switch self {
        case .deadHang, .planche, .frontLever, .backLever, .humanFlag, .bridge, .wallHandstand, .lSit, .skinTheCat, .handstandHold, .handstandWalk, .elbowLever:
            return .time
        default:
            return .weightAndReps
        }
    }
}

//
//  ExerciseModel.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

enum ExerciseModel: String, Identifiable, Hashable, CaseIterable {

    // MARK: - Trapezius

    case shrugs = "Shrugs"
    case uprightRows = "Upright Rows"
    case facePulls = "Face Pulls"
    case rackPulls = "Rack Pulls"
    case resistanceBandFacePulls = "Resistance Band Face Pulls"

    // MARK: - Deltoids

    case overheadPress = "Overhead Press"
    case arnoldPress = "Arnold Press"
    case lateralRaises = "Lateral Raises"
    case frontRaises = "Front Raises"
    case rearDeltFlyes = "Rear Delt Flyes"
    case resistanceBandLateralRaises = "Resistance Band Lateral Raises"
    case resistanceBandFrontRaises = "Resistance Band Front Raises"
    case resistanceBandOverheadPress = "Resistance Band Overhead Press"

    // MARK: - Biceps

    case bicepCurls = "Bicep Curls"
    case hammerCurls = "Hammer Curls"
    case chinUps = "Chin-ups"
    case concentrationCurls = "Concentration Curls"
    case preacherCurls = "Preacher Curls"
    case cableCurls = "Cable Curls"
    case reverseCurls = "Reverse Curls"
    case resistanceBandBicepCurls = "Resistance Band Bicep Curls"

    // MARK: - Triceps

    case tricepExtension = "Tricep Extension"
    case closeGripBenchPress = "Close-Grip Bench Press"
    case skullCrushers = "Skull Crushers"
    case overheadTricepsExtension = "Overhead Triceps Extension"
    case resistanceBandTricepsExtension = "Resistance Band Triceps Extension"

    // MARK: - Forearms

    case deadHang = "Dead Hang"
    case wristCurls = "Wrist Curls"
    case reverseWristCurls = "Reverse Wrist Curls"
    case resistanceBandWristCurls = "Resistance Band Wrist Curls"
    case resistanceBandReverseWristCurls = "Resistance Band Reverse Wrist Curls"
    case farmerWalk = "Farmer's Walk"
    case pinchGripHold = "Pinch Grip Hold"

    // MARK: - Pectorals

    case dips = "Dips"
    case pushUps = "Push-ups"
    case widePushUps = "Wide Push-ups"
    case diamondPushUps = "Diamond Push-ups"
    case inclinePushUps = "Incline Push-Ups"
    case dumbbellFlyes = "Dumbbell Flyes"
    case benchPress = "Bench Press"
    case chestPress = "Chest Press"
    case cableCrossover = "Cable Crossover"
    case inclineBenchPress = "Incline Bench Press"
    case declineBenchPress = "Decline Bench Press"
    case resistanceBandChestPress = "Resistance Band Chest Press"
    case resistanceBandFlyes = "Resistance Band Flyes"
    case machineChestPress = "Machine Chest Press"

    // MARK: - Abdominals

    case crunches = "Crunches"
    case russianTwist = "Russian Twist"
    case legRaises = "Leg Raises"
    case obliqueTwist = "Oblique Twist"
    case lSit = "L-sit"
    case legRaisesBar = "Leg Raises on Bar"
    case legRaisesParallettes = "Leg Raises on Parallettes"
    case plank = "Plank"
    case sidePlank = "Side Plank"
    case dragonFlag = "Dragon Flag"

    // MARK: - Central Back

    case reverseFlyes = "Reverse Flyes"
    case seatedRowWideGrip = "Seated Row (Wide Grip)"
    case proneYRaises = "Prone Y-Raises"

    // MARK: - Lats

    case pullUps = "Pull-ups"
    case latPulldowns = "Lat Pulldowns"
    case barbellRows = "Barbell Rows"
    case dumbbellRows = "Dumbbell Rows"
    case seatedCableRows = "Seated Cable Rows"
    case tBarRows = "T-Bar Rows"
    case oneArmPullUp = "One Arm Pull-up"
    case resistanceBandPulldowns = "Resistance Band Pulldowns"
    case resistanceBandRows = "Resistance Band Rows"
    case invertedRows = "Inverted Rows"
    case machineRows = "Machine Rows"
    case australianPullUps = "Australian Pull-ups"

    // MARK: - Lower Back

    case hyperextensions = "Hyperextensions"
    case goodMornings = "Good Mornings"
    case superman = "Superman"
    case backExtensions = "Back Extensions"

    // MARK: - Glutes

    case gluteBridge = "Glute Bridge"
    case hipThrust = "Hip Thrust"
    case deadlifts = "Deadlifts"
    case sumoDeadlifts = "Sumo Deadlifts"

    // MARK: - Quadriceps

    case squats = "Squats"
    case lunges = "Lunges"
    case legPress = "Leg Press"
    case splitSquat = "Split Squat"
    case bulgarianSplitSquat = "Bulgarian Split Squat"
    case pistolSquat = "Pistol Squat"
    case stepUps = "Step Ups"
    case hackSquat = "Hack Squat"
    case sissySquat = "Sissy Squat"
    case legExtensions = "Leg Extensions"
    case jumpSquats = "Jump Squats"
    case wallSit = "Wall Sit"

    // MARK: - Hamstrings

    case legCurls = "Leg Curls"
    case romanianDeadlifts = "Romanian Deadlifts"
    case nordicCurls = "Nordic Curls"
    case gluteHamRaises = "Glute-Ham Raises"

    // MARK: - Adductors

    case cableHipAdduction = "Cable Hip Adduction"
    case sideLyingAdductorRaises = "Side-Lying Adductor Raises"
    case copenhagenPlank = "Copenhagen Plank"

    // MARK: - Abductors

    case sideLyingLegRaises = "Side-Lying Leg Raises"
    case clamshells = "Clamshells"
    case resistanceBandLateralWalks = "Resistance Band Lateral Walks"

    // MARK: - Calves

    case calfRaises = "Calf Raises"
    case toeRaises = "Toe Raises"
    case seatedCalfRaises = "Seated Calf Raises"
    case standingCalfRaises = "Standing Calf Raises"
    case donkeyCalfRaises = "Donkey Calf Raises"

    // MARK: - Calisthenics

    case planche = "Planche"
    case muscleUps = "Muscle-ups"
    case frontLever = "Front Lever"
    case backLever = "Back Lever"
    case elbowLever = "Elbow Lever"
    case humanFlag = "Human Flag"
    case handstandPushUps = "Handstand Push-ups"
    case scapulaPullUps = "Scapula Pull-ups"
    case scapulaPushUps = "Scapula Push-ups"
    case pikePushUps = "Pike Push-ups"
    case plancheLean = "Planche Lean"
    case frogPose = "Frog Pose"
    case handstandToeTouch = "Handstand Toe Touch"
    case lSitLegLifts = "L-Sit Leg Lifts"

    // MARK: - Full Body

    case burpees = "Burpees"
    case mountainClimbers = "Mountain Climbers"
    case jumpingJacks = "Jumping Jacks"
    case squatThrusts = "Squat Thrusts"
    case bearCrawls = "Bear Crawls"
    case inchworms = "Inchworms"
    case manMakers = "Man Makers"
    case cleanAndPress = "Clean and Press"
    case snatch = "Snatch"
    case thrusters = "Thrusters"
    case wallBalls = "Wall Balls"
    case kettlebellSwings = "Kettlebell Swings"
    case battleRopes = "Battle Ropes"
    case sledPush = "Sled Push"
    case tireFlips = "Tire Flips"

    var id: String { rawValue }
}

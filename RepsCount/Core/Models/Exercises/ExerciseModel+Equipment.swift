//
//  ExerciseModel+Equipment.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

extension ExerciseModel {
    var equipment: ExerciseEquipment {
        switch self {
        // MARK: - Trapezius
        case .shrugs:
            return .gym // Dumbbells or barbell typically used
        case .uprightRows:
            return .gym // Barbell or dumbbells
        case .facePulls:
            return .gym // Cable machine or resistance bands could work, but gym is primary
        case .rackPulls:
            return .gym // Barbell and rack required
        case .resistanceBandFacePulls:
            return .resistanceBands

        // MARK: - Deltoids
        case .overheadPress:
            return .gym // Barbell or dumbbells
        case .arnoldPress:
            return .gym // Dumbbells
        case .lateralRaises:
            return .gym // Dumbbells
        case .frontRaises:
            return .gym // Dumbbells
        case .rearDeltFlyes:
            return .gym // Dumbbells or cable machine
        case .handstandPushUps:
            return .none // Bodyweight exercise
        case .resistanceBandLateralRaises:
            return .resistanceBands
        case .resistanceBandFrontRaises:
            return .resistanceBands
        case .resistanceBandOverheadPress:
            return .resistanceBands

        // MARK: - Biceps
        case .bicepCurls:
            return .gym // Dumbbells or barbell
        case .hammerCurls:
            return .gym // Dumbbells
        case .chinUps:
            return .bars // Pull-up bar
        case .concentrationCurls:
            return .gym // Dumbbell
        case .preacherCurls:
            return .gym // Preacher bench and barbell/dumbbell
        case .cableCurls:
            return .gym // Cable machine
        case .reverseCurls:
            return .gym // Barbell or dumbbells
        case .resistanceBandBicepCurls:
            return .resistanceBands

        // MARK: - Triceps
        case .tricepExtension:
            return .gym // Dumbbell or cable machine
        case .closeGripBenchPress:
            return .gym // Barbell and bench
        case .skullCrushers:
            return .gym // Barbell or dumbbells
        case .overheadTricepsExtension:
            return .gym // Dumbbell or cable
        case .resistanceBandTricepsExtension:
            return .resistanceBands

        // MARK: - Forearms
        case .deadHang:
            return .bars // Pull-up bar
        case .wristCurls:
            return .gym // Dumbbells or barbell
        case .reverseWristCurls:
            return .gym // Dumbbells or barbell
        case .resistanceBandWristCurls:
            return .resistanceBands
        case .resistanceBandReverseWristCurls:
            return .resistanceBands
        case .farmerWalk:
            return .gym // Dumbbells or kettlebells
        case .pinchGripHold:
            return .gym // Weight plates or pinch blocks

        // MARK: - Pectorals
        case .dips:
            return .bars // Dip bars or parallel bars
        case .pushUps:
            return .none // Bodyweight exercise
        case .diamondPushUps:
            return .none // Bodyweight exercise
        case .dumbbellFlyes:
            return .gym // Dumbbells and bench
        case .benchPress:
            return .gym // Barbell and bench
        case .chestPress:
            return .gym // Machine or dumbbells
        case .cableCrossover:
            return .gym // Cable machine
        case .inclineBenchPress:
            return .gym // Barbell and incline bench
        case .declineBenchPress:
            return .gym // Barbell and decline bench
        case .resistanceBandChestPress:
            return .resistanceBands
        case .resistanceBandFlyes:
            return .resistanceBands
        case .machineChestPress:
            return .gym // Chest press machine

        // MARK: - Abdominals
        case .crunches:
            return .none // Bodyweight exercise
        case .russianTwist:
            return .none // Bodyweight, optional weight
        case .legRaises:
            return .none // Bodyweight exercise
        case .obliqueTwist:
            return .none // Bodyweight, optional weight
        case .lSit:
            return .bars // Parallettes or dip bars often used
        case .legRaisesBar:
            return .bars // Pull-up bar
        case .legRaisesParallettes:
            return .bars // Parallettes
        case .plank:
            return .none // Bodyweight exercise
        case .sidePlank:
            return .none // Bodyweight exercise
        case .dragonFlag:
            return .none // Bodyweight, optional bench

        // MARK: - Central Back
        case .reverseFlyes:
            return .gym // Dumbbells or cable machine
        case .seatedRowWideGrip:
            return .gym // Cable machine
        case .proneYRaises:
            return .none // Bodyweight, optional light dumbbells

        // MARK: - Lats
        case .pullUps:
            return .bars // Pull-up bar
        case .latPulldowns:
            return .gym // Lat pulldown machine
        case .barbellRows:
            return .gym // Barbell
        case .dumbbellRows:
            return .gym // Dumbbell
        case .seatedCableRows:
            return .gym // Cable machine
        case .tBarRows:
            return .gym // T-bar row machine or barbell
        case .oneArmPullUp:
            return .bars // Pull-up bar
        case .resistanceBandPulldowns:
            return .resistanceBands
        case .resistanceBandRows:
            return .resistanceBands
        case .invertedRows:
            return .bars // Bar or rings under a low bar
        case .machineRows:
            return .gym // Rowing machine

        // MARK: - Lower Back
        case .hyperextensions:
            return .gym // Hyperextension bench
        case .goodMornings:
            return .gym // Barbell
        case .superman:
            return .none // Bodyweight exercise
        case .backExtensions:
            return .gym // Back extension bench

        // MARK: - Glutes
        case .gluteBridge:
            return .none // Bodyweight, optional weight
        case .hipThrust:
            return .gym // Barbell and bench
        case .deadlifts:
            return .gym // Barbell
        case .sumoDeadlifts:
            return .gym // Barbell

        // MARK: - Quadriceps
        case .squats:
            return .none // Bodyweight, optional barbell (gym)
        case .lunges:
            return .none // Bodyweight, optional dumbbells (gym)
        case .legPress:
            return .gym // Leg press machine
        case .splitSquat:
            return .none // Bodyweight, optional dumbbells (gym)
        case .bulgarianSplitSquat:
            return .gym // Dumbbells and bench
        case .pistolSquat:
            return .none // Bodyweight exercise
        case .stepUps:
            return .none // Bodyweight, optional dumbbells and step (gym)
        case .hackSquat:
            return .gym // Hack squat machine
        case .sissySquat:
            return .none // Bodyweight, optional support
        case .legExtensions:
            return .gym // Leg extension machine

        // MARK: - Hamstrings
        case .legCurls:
            return .gym // Leg curl machine
        case .romanianDeadlifts:
            return .gym // Barbell or dumbbells
        case .nordicCurls:
            return .none // Bodyweight, optional partner or anchor
        case .gluteHamRaises:
            return .gym // Glute-ham developer machine

        // MARK: - Adductors
        case .cableHipAdduction:
            return .gym // Cable machine
        case .sideLyingAdductorRaises:
            return .none // Bodyweight exercise
        case .copenhagenPlank:
            return .none // Bodyweight, optional bench

        // MARK: - Abductors
        case .sideLyingLegRaises:
            return .none // Bodyweight exercise
        case .clamshells:
            return .none // Bodyweight, optional resistance band
        case .resistanceBandLateralWalks:
            return .resistanceBands

        // MARK: - Calves
        case .calfRaises:
            return .none // Bodyweight, optional step
        case .toeRaises:
            return .none // Bodyweight exercise
        case .seatedCalfRaises:
            return .gym // Seated calf raise machine
        case .standingCalfRaises:
            return .gym // Standing calf raise machine or dumbbells
        case .donkeyCalfRaises:
            return .gym // Donkey calf raise machine or partner

            // MARK: - Calisthenics
        case .planche:
            return .bars // Parallettes or floor, but bars common for training
        case .muscleUps:
            return .bars // Pull-up bar or rings
        case .frontLever:
            return .bars // Pull-up bar
        case .backLever:
            return .bars // Pull-up bar or rings
        case .humanFlag:
            return .bars // Vertical pole or bar

        case .australianPullUps:
            return .bars
        case .jumpSquats:
            return .none
        case .burpees:
            return .none
        case .mountainClimbers:
            return .none
        case .jumpingJacks:
            return .none
        case .squatThrusts:
            return .none
        case .bearCrawls:
            return .none
        case .inchworms:
            return .none
        case .manMakers:
            return .gym // Typically done with dumbbells
        case .cleanAndPress:
            return .gym // Usually requires barbell or dumbbells
        case .snatch:
            return .gym // Requires barbell
        case .thrusters:
            return .gym // Dumbbells or barbell
        case .wallBalls:
            return .gym // Medicine ball and wall target
        case .kettlebellSwings:
            return .gym // Kettlebell needed
        case .battleRopes:
            return .gym
        case .sledPush:
            return .gym
        case .tireFlips:
            return .gym
        case .widePushUps:
            return .none
        case .inclinePushUps:
            return .none
        case .wallSit:
            return .none
        case .elbowLever:
            return .none
        case .scapulaPullUps:
            return .bars
        case .scapulaPushUps:
            return .none
        case .pikePushUps:
            return .none
        case .plancheLean:
            return .none
        case .frogPose:
            return .none
        case .handstandToeTouch:
            return .none
        case .lSitLegLifts:
            return .bars
        }
    }
}

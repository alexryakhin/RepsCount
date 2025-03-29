//
//  ExerciseModel.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

public extension ExerciseModel {
    var categories: [ExerciseCategory] {
        switch self {
        case .shrugs:
            return [.trapezius]
        case .uprightRows:
            return [.trapezius]
        case .facePulls:
            return [.trapezius]
        case .rackPulls:
            return [.trapezius]
        case .resistanceBandFacePulls:
            return [.trapezius]
        case .overheadPress:
            return [.deltoids]
        case .arnoldPress:
            return [.deltoids]
        case .lateralRaises:
            return [.deltoids]
        case .frontRaises:
            return [.deltoids]
        case .rearDeltFlyes:
            return [.deltoids]
        case .handstandPushUps:
            return [.deltoids]
        case .resistanceBandLateralRaises:
            return [.deltoids]
        case .resistanceBandFrontRaises:
            return [.deltoids]
        case .resistanceBandOverheadPress:
            return [.deltoids]
        case .bicepCurls:
            return [.biceps]
        case .resistanceBandBicepCurls:
            return [.biceps]
        case .hammerCurls:
            return [.biceps]
        case .chinUps:
            return [.biceps, .lats]
        case .concentrationCurls:
            return [.biceps]
        case .preacherCurls:
            return [.biceps]
        case .cableCurls:
            return [.biceps]
        case .reverseCurls:
            return [.biceps]
        case .tricepExtension:
            return [.triceps]
        case .closeGripBenchPress:
            return [.triceps]
        case .skullCrushers:
            return [.triceps]
        case .overheadTricepsExtension:
            return [.triceps]
        case .resistanceBandTricepsExtension:
            return [.triceps]
        case .deadHang:
            return [.forearms]
        case .wristCurls:
            return [.forearms]
        case .reverseWristCurls:
            return [.forearms]
        case .resistanceBandWristCurls:
            return [.forearms]
        case .resistanceBandReverseWristCurls:
            return [.forearms]
        case .farmerWalk:
            return [.forearms]
        case .pinchGripHold:
            return [.forearms]
        case .dips:
            return [.pectorals]
        case .pushUps:
            return [.pectorals]
        case .diamondPushUps:
            return [.pectorals]
        case .dumbbellFlyes:
            return [.pectorals]
        case .benchPress:
            return [.pectorals]
        case .chestPress:
            return [.pectorals]
        case .cableCrossover:
            return [.pectorals]
        case .inclineBenchPress:
            return [.pectorals]
        case .declineBenchPress:
            return [.pectorals]
        case .resistanceBandChestPress:
            return [.pectorals]
        case .resistanceBandFlyes:
            return [.pectorals]
        case .machineChestPress:
            return [.pectorals]
        case .crunches:
            return [.abdominals]
        case .russianTwist:
            return [.abdominals]
        case .legRaises:
            return [.abdominals]
        case .obliqueTwist:
            return [.abdominals]
        case .lSit:
            return [.abdominals]
        case .legRaisesBar:
            return [.abdominals]
        case .legRaisesParallettes:
            return [.abdominals]
        case .plank:
            return [.abdominals]
        case .sidePlank:
            return [.abdominals]
        case .dragonFlag:
            return [.abdominals]
        case .reverseFlyes:
            return [.centralBack]
        case .seatedRowWideGrip:
            return [.centralBack]
        case .proneYRaises:
            return [.centralBack]
        case .pullUps:
            return [.lats]
        case .latPulldowns:
            return [.lats]
        case .barbellRows:
            return [.lats]
        case .dumbbellRows:
            return [.lats]
        case .seatedCableRows:
            return [.lats]
        case .tBarRows:
            return [.lats]
        case .oneArmPullUp:
            return [.lats]
        case .resistanceBandPulldowns:
            return [.lats]
        case .resistanceBandRows:
            return [.lats]
        case .invertedRows:
            return [.lats]
        case .machineRows:
            return [.lats]
        case .hyperextensions:
            return [.lowerBack]
        case .goodMornings:
            return [.lowerBack]
        case .superman:
            return [.lowerBack]
        case .backExtensions:
            return [.lowerBack]
        case .gluteBridge:
            return [.glutes]
        case .hipThrust:
            return [.glutes]
        case .deadlifts:
            return [.glutes, .hamstrings]
        case .sumoDeadlifts:
            return [.glutes, .adductors]
        case .squats:
            return [.glutes, .quadriceps]
        case .lunges:
            return [.glutes, .quadriceps]
        case .legPress:
            return [.quadriceps]
        case .splitSquat:
            return [.glutes, .quadriceps]
        case .bulgarianSplitSquat:
            return [.glutes, .quadriceps]
        case .pistolSquat:
            return [.glutes, .quadriceps]
        case .stepUps:
            return [.glutes, .quadriceps]
        case .hackSquat:
            return [.quadriceps]
        case .sissySquat:
            return [.quadriceps]
        case .legExtensions:
            return [.quadriceps]
        case .legCurls:
            return [.hamstrings]
        case .romanianDeadlifts:
            return [.hamstrings]
        case .nordicCurls:
            return [.hamstrings]
        case .gluteHamRaises:
            return [.hamstrings]
        case .cableHipAdduction:
            return [.adductors]
        case .sideLyingAdductorRaises:
            return [.adductors]
        case .copenhagenPlank:
            return [.adductors]
        case .sideLyingLegRaises:
            return [.abductors]
        case .clamshells:
            return [.abductors]
        case .resistanceBandLateralWalks:
            return [.abductors]
        case .calfRaises:
            return [.calves]
        case .toeRaises:
            return [.calves]
        case .seatedCalfRaises:
            return [.calves]
        case .standingCalfRaises:
            return [.calves]
        case .donkeyCalfRaises:
            return [.calves]

            // MARK: - Calisthenics
        case .planche:
            return [.pectorals, .deltoids, .abdominals]
        case .muscleUps:
            return [.lats, .biceps, .triceps]
        case .frontLever:
            return [.lats, .abdominals]
        case .backLever:
            return [.lats, .abdominals]
        case .humanFlag:
            return [.abdominals, .lats]

        case .australianPullUps:
            return [.lats, .biceps]
        case .jumpSquats:
            return [.quadriceps, .glutes, .calves]
        case .burpees:
            return [.pectorals, .quadriceps, .abdominals, .triceps, .deltoids]
        case .mountainClimbers:
            return [.abdominals, .quadriceps, .deltoids]
        case .jumpingJacks:
            return [.calves, .abductors, .deltoids]
        case .squatThrusts:
            return [.quadriceps, .pectorals, .triceps, .abdominals]
        case .bearCrawls:
            return [.deltoids, .triceps, .abdominals, .quadriceps]
        case .inchworms:
            return [.hamstrings, .abdominals, .pectorals]
        case .manMakers:
            return [.quadriceps, .deltoids, .triceps, .pectorals, .abdominals]
        case .cleanAndPress:
            return [.quadriceps, .deltoids, .trapezius, .glutes]
        case .snatch:
            return [.quadriceps, .glutes, .trapezius, .deltoids]
        case .thrusters:
            return [.quadriceps, .glutes, .deltoids, .triceps]
        case .wallBalls:
            return [.quadriceps, .glutes, .deltoids]
        case .kettlebellSwings:
            return [.glutes, .hamstrings, .lowerBack]
        case .battleRopes:
            return [.deltoids, .forearms, .abdominals]
        case .sledPush:
            return [.quadriceps, .glutes, .calves]
        case .tireFlips:
            return [.quadriceps, .glutes, .trapezius, .lowerBack]
        case .widePushUps:
            return [.pectorals, .triceps, .deltoids]
        case .inclinePushUps:
            return [.pectorals, .triceps, .deltoids]
        case .wallSit:
            return [.quadriceps, .glutes]
        case .elbowLever:
            return [.abdominals, .pectorals, .triceps]
        case .scapulaPullUps:
            return [.lats, .trapezius]
        case .scapulaPushUps:
            return [.pectorals, .trapezius]
        case .pikePushUps:
            return [.deltoids, .triceps, .pectorals]
        case .plancheLean:
            return [.pectorals, .abdominals, .deltoids]
        case .frogPose:
            return [.adductors, .abdominals]
        case .handstandToeTouch:
            return [.deltoids, .abdominals, .trapezius]
        case .lSitLegLifts:
            return [.abdominals, .quadriceps]
        }
    }
}

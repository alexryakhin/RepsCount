//
//  ExerciseCategory.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/12/25.
//

public enum ExerciseCategory: String, CaseIterable {
    case trapezius = "Trapezius"
    case deltoids = "Deltoids"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case forearms = "Forearms"
    case pectorals = "Pectorals"
    case abdominals = "Abdominals"
    case centralBack = "Central Back"
    case lats = "Lats"
    case lowerBack = "Lower Back"
    case glutes = "Glutes"
    case quadriceps = "Quadriceps"
    case hamstrings = "Hamstrings"
    case adductors = "Adductors"
    case abductors = "Abductors"
    case calves = "Calves"

    public var exercises: [ExerciseModel] {
        switch self {
        case .trapezius:
            return [
                .shrugs,
                .uprightRows,
                .facePulls,
                .rackPulls,
                .resistanceBandFacePulls
            ]
        case .deltoids:
            return [
                .overheadPress,
                .arnoldPress,
                .lateralRaises,
                .frontRaises,
                .rearDeltFlyes,
                .handstandPushUps,
                .resistanceBandLateralRaises,
                .resistanceBandFrontRaises,
                .resistanceBandOverheadPress,
                .planche
            ]
        case .biceps:
            return [
                .bicepCurls,
                .hammerCurls,
                .chinUps,
                .concentrationCurls,
                .preacherCurls,
                .cableCurls,
                .reverseCurls,
                .resistanceBandBicepCurls,
                .muscleUps
            ]
        case .triceps:
            return [
                .tricepExtension,
                .closeGripBenchPress,
                .skullCrushers,
                .overheadTricepsExtension,
                .resistanceBandTricepsExtension,
                .muscleUps
            ]
        case .forearms:
            return [
                .deadHang,
                .wristCurls,
                .reverseWristCurls,
                .resistanceBandWristCurls,
                .resistanceBandReverseWristCurls,
                .farmerWalk,
                .pinchGripHold
            ]
        case .pectorals:
            return [
                .dips,
                .pushUps,
                .diamondPushUps,
                .dumbbellFlyes,
                .benchPress,
                .chestPress,
                .cableCrossover,
                .inclineBenchPress,
                .declineBenchPress,
                .resistanceBandChestPress,
                .resistanceBandFlyes,
                .machineChestPress,
                .planche
            ]
        case .abdominals:
            return [
                .crunches,
                .russianTwist,
                .legRaises,
                .obliqueTwist,
                .lSit,
                .legRaisesBar,
                .legRaisesParallettes,
                .plank,
                .sidePlank,
                .dragonFlag,
                .planche,
                .frontLever,
                .backLever,
                .humanFlag
            ]
        case .centralBack:
            return [
                .reverseFlyes,
                .seatedRowWideGrip,
                .proneYRaises
            ]
        case .lats:
            return [
                .pullUps,
                .latPulldowns,
                .barbellRows,
                .dumbbellRows,
                .seatedCableRows,
                .tBarRows,
                .oneArmPullUp,
                .resistanceBandPulldowns,
                .resistanceBandRows,
                .invertedRows,
                .machineRows,
                .muscleUps,
                .frontLever,
                .backLever,
                .humanFlag
            ]
        case .lowerBack:
            return [
                .hyperextensions,
                .goodMornings,
                .superman,
                .backExtensions
            ]
        case .glutes:
            return [
                .gluteBridge,
                .hipThrust,
                .deadlifts,
                .sumoDeadlifts,
                .squats,
                .lunges,
                .splitSquat,
                .bulgarianSplitSquat,
                .pistolSquat,
                .stepUps
            ]
        case .quadriceps:
            return [
                .squats,
                .lunges,
                .legPress,
                .splitSquat,
                .bulgarianSplitSquat,
                .pistolSquat,
                .stepUps,
                .hackSquat,
                .sissySquat,
                .legExtensions
            ]
        case .hamstrings:
            return [
                .legCurls,
                .romanianDeadlifts,
                .nordicCurls,
                .gluteHamRaises,
                .deadlifts
            ]
        case .adductors:
            return [
                .cableHipAdduction,
                .sideLyingAdductorRaises,
                .copenhagenPlank,
                .sumoDeadlifts
            ]
        case .abductors:
            return [
                .sideLyingLegRaises,
                .clamshells,
                .resistanceBandLateralWalks
            ]
        case .calves:
            return [
                .calfRaises,
                .toeRaises,
                .seatedCalfRaises,
                .standingCalfRaises,
                .donkeyCalfRaises
            ]
        }
    }
}

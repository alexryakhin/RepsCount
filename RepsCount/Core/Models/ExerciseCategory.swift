//
//  ExerciseCategory.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/12/25.
//

public enum ExerciseCategory: String, CaseIterable {
    case legs = "Legs"
    case core = "Core"
    case arms = "Arms"
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"

    case strengthSkills = "Strength Skills"
    case mobility = "Mobility"
    case balance = "Balance"

    public var type: ExerciseType {
        switch self {
        case .legs, .core, .arms, .chest, .back, .shoulders:
                .strengthTraining
        case .strengthSkills, .mobility, .balance:
                .calisthenics
        }
    }

    public var exercises: [ExerciseModel] {
        switch self {
        case .legs:
            [.squats, .lunges, .legPress, .deadlifts, .legCurls, .calfRaises, .toeRaises, .splitSquat, .bulgarianSplitSquat, .pistolSquat]
        case .core:
            [.crunches, .russianTwist, .legRaises, .obliqueTwist, .superman]
        case .arms:
            [.bicepCurls, .tricepDips, .hammerCurls, .tricepExtension, .chinUps]
        case .chest:
            [.dips, .pushUps, .diamondPushUps, .dumbbellFlyes, .benchPress, .chestPress, .cableCrossover, .inclineBenchPress]
        case .back:
            [.pullUps, .latPulldowns, .barbellRows, .dumbbellRows, .seatedCableRows, .tBarRows, .hyperextensions, .facePulls, .reverseFlyes, .oneArmPullUp]
        case .shoulders:
            [.overheadPress, .arnoldPress, .lateralRaises, .frontRaises, .rearDeltFlyes, .uprightRows, .shrugs, .pushPress, .handstandPushUps]
        case .strengthSkills:
            [.deadHang, .planche, .frontLever, .backLever, .humanFlag, .muscleUps]
        case .mobility:
            [.bridge, .wallHandstand, .lSit, .skinTheCat]
        case .balance:
            [.handstandHold, .handstandWalk, .elbowLever]
        }
    }
}

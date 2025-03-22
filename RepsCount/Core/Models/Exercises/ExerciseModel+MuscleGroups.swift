//
//  ExerciseModel+MuscleGroups.swift
//  Core
//
//  Created by Aleksandr Riakhin on 3/11/25.
//
//

import Foundation

public extension ExerciseModel {
    var primaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .shrugs:
            [.trapezius]
        case .uprightRows:
            [.trapezius, .deltoids]
        case .facePulls:
            [.trapezius, .rhomboidMajor]
        case .rackPulls:
            [.trapezius, .latissimusDorsi, .gluteusMaximus, .bicepsFemoris]
        case .resistanceBandFacePulls:
            [.trapezius, .rhomboidMajor]
        case .overheadPress:
            [.deltoids, .triceps]
        case .arnoldPress:
            [.deltoids, .triceps]
        case .lateralRaises:
            [.deltoids]
        case .frontRaises:
            [.deltoids]
        case .rearDeltFlyes:
            [.deltoids, .trapezius]
        case .handstandPushUps:
            [.deltoids, .triceps]
        case .resistanceBandLateralRaises:
            [.deltoids]
        case .resistanceBandFrontRaises:
            [.deltoids]
        case .resistanceBandOverheadPress:
            [.deltoids, .triceps]
        case .bicepCurls:
            [.biceps]
        case .resistanceBandBicepCurls:
            [.biceps]
        case .hammerCurls:
            [.biceps, .brachioradialis]
        case .chinUps:
            [.biceps, .latissimusDorsi, .trapezius]
        case .concentrationCurls:
            [.biceps]
        case .preacherCurls:
            [.biceps]
        case .cableCurls:
            [.biceps]
        case .reverseCurls:
            [.brachioradialis, .biceps]
        case .tricepExtension:
            [.triceps]
        case .closeGripBenchPress:
            [.triceps, .pectoralisMajor]
        case .skullCrushers:
            [.triceps]
        case .overheadTricepsExtension:
            [.triceps]
        case .resistanceBandTricepsExtension:
            [.triceps]
        case .deadHang:
            [.latissimusDorsi, .biceps]
        case .wristCurls:
            [.flexorCarpiRadialis]
        case .reverseWristCurls:
            [.extensorCarpiRadialis]
        case .resistanceBandWristCurls:
            [.flexorCarpiRadialis]
        case .resistanceBandReverseWristCurls:
            [.extensorCarpiRadialis]
        case .farmerWalk:
            [.trapezius, .flexorCarpiRadialis]
        case .pinchGripHold:
            [.flexorCarpiRadialis]
        case .dips:
            [.triceps, .pectoralisMajor]
        case .pushUps:
            [.pectoralisMajor, .triceps]
        case .diamondPushUps:
            [.triceps, .pectoralisMajor]
        case .dumbbellFlyes:
            [.pectoralisMajor]
        case .benchPress:
            [.pectoralisMajor, .triceps]
        case .chestPress:
            [.pectoralisMajor, .triceps]
        case .cableCrossover:
            [.pectoralisMajor]
        case .inclineBenchPress:
            [.pectoralisMajor, .triceps]
        case .declineBenchPress:
            [.pectoralisMajor, .triceps]
        case .resistanceBandChestPress:
            [.pectoralisMajor, .triceps]
        case .resistanceBandFlyes:
            [.pectoralisMajor]
        case .machineChestPress:
            [.pectoralisMajor, .triceps]
        case .crunches:
            [.rectusAbdominis]
        case .russianTwist:
            [.externalObliques, .rectusAbdominis]
        case .legRaises:
            [.rectusAbdominisLower]
        case .obliqueTwist:
            [.externalObliques]
        case .lSit:
            [.rectusAbdominis, .rectusFemoris, .tensorFasciaeLatae]
        case .legRaisesBar:
            [.rectusAbdominisLower]
        case .legRaisesParallettes:
            [.rectusAbdominisLower]
        case .plank:
            [.rectusAbdominis]
        case .sidePlank:
            [.externalObliques]
        case .dragonFlag:
            [.rectusAbdominis]
        case .reverseFlyes:
            [.rhomboidMajor, .trapezius]
        case .seatedRowWideGrip:
            [.rhomboidMajor, .trapezius]
        case .proneYRaises:
            [.lowerTrapezius, .trapezius, .deltoids]
        case .pullUps:
            [.latissimusDorsi, .biceps]
        case .latPulldowns:
            [.latissimusDorsi]
        case .barbellRows:
            [.latissimusDorsi, .trapezius]
        case .dumbbellRows:
            [.latissimusDorsi]
        case .seatedCableRows:
            [.latissimusDorsi]
        case .tBarRows:
            [.latissimusDorsi, .trapezius]
        case .oneArmPullUp:
            [.latissimusDorsi, .biceps]
        case .resistanceBandPulldowns:
            [.latissimusDorsi]
        case .resistanceBandRows:
            [.latissimusDorsi]
        case .invertedRows:
            [.latissimusDorsi, .biceps]
        case .machineRows:
            [.latissimusDorsi]
        case .hyperextensions:
            [.gluteusMaximus, .bicepsFemoris]
        case .goodMornings:
            [.gluteusMaximus, .bicepsFemoris]
        case .superman:
            [.gluteusMaximus, .thoracolumbarFascia]
        case .backExtensions:
            [.gluteusMaximus, .bicepsFemoris]
        case .gluteBridge:
            [.gluteusMaximus]
        case .hipThrust:
            [.gluteusMaximus]
        case .deadlifts:
            [.gluteusMaximus, .bicepsFemoris, .latissimusDorsi]
        case .sumoDeadlifts:
            [.gluteusMaximus, .adductorMagnus]
        case .squats:
            [.gluteusMaximus, .rectusFemoris, .vastusLateralis, .vastusMedialis]
        case .lunges:
            [.gluteusMaximus, .rectusFemoris]
        case .legPress:
            [.gluteusMaximus, .rectusFemoris, .vastusLateralis]
        case .splitSquat:
            [.gluteusMaximus, .rectusFemoris]
        case .bulgarianSplitSquat:
            [.gluteusMaximus, .rectusFemoris]
        case .pistolSquat:
            [.gluteusMaximus, .rectusFemoris, .gluteusMedius, .vastusLateralis, .vastusMedialis]
        case .stepUps:
            [.gluteusMaximus, .rectusFemoris]
        case .hackSquat:
            [.gluteusMaximus, .rectusFemoris, .vastusLateralis]
        case .sissySquat:
            [.rectusFemoris]
        case .legExtensions:
            [.rectusFemoris]
        case .legCurls:
            [.bicepsFemoris, .semitendinosus]
        case .romanianDeadlifts:
            [.gluteusMaximus, .bicepsFemoris]
        case .nordicCurls:
            [.bicepsFemoris]
        case .gluteHamRaises:
            [.gluteusMaximus, .bicepsFemoris]
        case .cableHipAdduction:
            [.adductorMagnus, .gracilis]
        case .sideLyingAdductorRaises:
            [.adductorMagnus, .gracilis]
        case .copenhagenPlank:
            [.adductorMagnus, .gracilis]
        case .sideLyingLegRaises:
            [.gluteusMedius, .tensorFasciaeLatae]
        case .clamshells:
            [.gluteusMedius]
        case .resistanceBandLateralWalks:
            [.gluteusMedius, .tensorFasciaeLatae]
        case .calfRaises:
            [.gastrocnemius]
        case .toeRaises:
            [.peroneusLongus]
        case .seatedCalfRaises:
            [.soleus]
        case .standingCalfRaises:
            [.gastrocnemius]
        case .donkeyCalfRaises:
            [.gastrocnemius]

            // MARK: - Calisthenics
        case .planche:
            [.deltoids, .pectoralisMajor, .triceps, .rectusAbdominis, .rectusAbdominisLower]
        case .muscleUps:
            [.latissimusDorsi, .biceps, .triceps] // Pull-up phase dominates
        case .frontLever:
            [.latissimusDorsi, .rectusAbdominis, .deltoids] // Back and core for tension
        case .backLever:
            [.latissimusDorsi, .rectusAbdominis, .rectusAbdominisLower, .deltoids] // Back and core for leverage
        case .humanFlag:
            [.externalObliques, .latissimusDorsi, .triceps] // Obliques and lats for lateral hold
        }
    }

    var secondaryMuscleGroups: [MuscleGroup] {
        switch self {
        case .shrugs:
            [.rhomboidMajor, .sternocleidomastoid]
        case .uprightRows:
            [.biceps, .triceps]
        case .facePulls:
            [.trapezius, .rhomboidMajor, .deltoids]
        case .rackPulls:
            [.trapezius, .latissimusDorsi, .gluteusMaximus, .bicepsFemoris, .thoracolumbarFascia]
        case .resistanceBandFacePulls:
            [.deltoids, .infraspinatus]
        case .overheadPress:
            [.trapezius, .rectusAbdominis]
        case .arnoldPress:
            [.trapezius, .rectusAbdominis]
        case .lateralRaises:
            [.trapezius]
        case .frontRaises:
            [.trapezius, .pectoralisMajor]
        case .rearDeltFlyes:
            [.rhomboidMajor, .infraspinatus]
        case .handstandPushUps:
            [.trapezius, .rectusAbdominis]
        case .resistanceBandLateralRaises:
            [.trapezius]
        case .resistanceBandFrontRaises:
            [.trapezius, .pectoralisMajor]
        case .resistanceBandOverheadPress:
            [.trapezius, .rectusAbdominis]
        case .bicepCurls:
            [.brachialis, .brachioradialis]
        case .resistanceBandBicepCurls:
            [.brachialis, .brachioradialis]
        case .hammerCurls:
            [.flexorCarpiRadialis]
        case .chinUps:
            [.trapezius, .rhomboidMajor, .brachialis]
        case .concentrationCurls:
            [.brachialis]
        case .preacherCurls:
            [.brachialis]
        case .cableCurls:
            [.brachialis, .flexorCarpiRadialis]
        case .reverseCurls:
            [.brachioradialis, .biceps]
        case .tricepExtension:
            [.deltoids]
        case .closeGripBenchPress:
            [.deltoids]
        case .skullCrushers:
            [.deltoids]
        case .overheadTricepsExtension:
            [.deltoids]
        case .resistanceBandTricepsExtension:
            [.deltoids]
        case .deadHang:
            [.trapezius, .flexorCarpiRadialis]
        case .wristCurls:
            [.flexorCarpiUlnaris]
        case .reverseWristCurls:
            [.extensorCarpiRadialis]
        case .resistanceBandWristCurls:
            [.flexorCarpiUlnaris]
        case .resistanceBandReverseWristCurls:
            [.extensorCarpiRadialis]
        case .farmerWalk:
            [.rectusAbdominis, .gluteusMaximus]
        case .pinchGripHold:
            [.flexorCarpiUlnaris]
        case .dips:
            [.deltoids, .rectusAbdominis, .serratusAnterior]
        case .pushUps:
            [.deltoids, .rectusAbdominis]
        case .diamondPushUps:
            [.deltoids, .rectusAbdominis]
        case .dumbbellFlyes:
            [.biceps, .triceps]
        case .benchPress:
            [.deltoids]
        case .chestPress:
            [.deltoids]
        case .cableCrossover:
            [.biceps, .serratusAnterior]
        case .inclineBenchPress:
            [.deltoids]
        case .declineBenchPress:
            [.deltoids]
        case .resistanceBandChestPress:
            [.deltoids]
        case .resistanceBandFlyes:
            [.biceps, .serratusAnterior]
        case .machineChestPress:
            [.deltoids]
        case .crunches:
            [.externalObliques]
        case .russianTwist:
            [.rectusAbdominis]
        case .legRaises:
            [.rectusAbdominis, .tensorFasciaeLatae]
        case .obliqueTwist:
            [.rectusAbdominis]
        case .lSit:
            [.rectusFemoris, .tensorFasciaeLatae]
        case .legRaisesBar:
            [.rectusAbdominis, .tensorFasciaeLatae]
        case .legRaisesParallettes:
            [.rectusAbdominis, .tensorFasciaeLatae]
        case .plank:
            [.externalObliques, .gluteusMedius]
        case .sidePlank:
            [.rectusAbdominis, .gluteusMedius]
        case .dragonFlag:
            [.externalObliques, .rectusFemoris]
        case .reverseFlyes:
            [.deltoids, .infraspinatus]
        case .seatedRowWideGrip:
            [.latissimusDorsi, .biceps]
        case .proneYRaises:
            [.deltoids, .rhomboidMajor]
        case .pullUps:
            [.trapezius, .rhomboidMajor, .teresMajor]
        case .latPulldowns:
            [.biceps, .trapezius]
        case .barbellRows:
            [.biceps, .rhomboidMajor]
        case .dumbbellRows:
            [.biceps, .trapezius]
        case .seatedCableRows:
            [.biceps, .trapezius]
        case .tBarRows:
            [.biceps, .rhomboidMajor]
        case .oneArmPullUp:
            [.trapezius, .rhomboidMajor]
        case .resistanceBandPulldowns:
            [.biceps, .trapezius]
        case .resistanceBandRows:
            [.biceps, .trapezius]
        case .invertedRows:
            [.trapezius, .rhomboidMajor]
        case .machineRows:
            [.biceps, .trapezius]
        case .hyperextensions:
            [.thoracolumbarFascia, .rectusAbdominis]
        case .goodMornings:
            [.thoracolumbarFascia, .rectusAbdominis]
        case .superman:
            [.deltoids, .semitendinosus]
        case .backExtensions:
            [.thoracolumbarFascia, .rectusAbdominis]
        case .gluteBridge:
            [.rectusFemoris, .thoracolumbarFascia]
        case .hipThrust:
            [.rectusFemoris, .bicepsFemoris]
        case .deadlifts:
            [.trapezius, .rectusAbdominis, .adductorMagnus]
        case .sumoDeadlifts:
            [.rectusFemoris, .vastusLateralis, .rectusAbdominis]
        case .squats:
            [.adductorMagnus, .rectusAbdominis, .gluteusMedius]
        case .lunges:
            [.adductorMagnus, .gluteusMedius]
        case .legPress:
            [.adductorMagnus, .rectusAbdominis]
        case .splitSquat:
            [.gluteusMedius, .adductorMagnus]
        case .bulgarianSplitSquat:
            [.gluteusMedius, .adductorMagnus]
        case .pistolSquat:
            [.gluteusMedius, .rectusAbdominis, .semitendinosus, .gastrocnemius]
        case .stepUps:
            [.gluteusMedius, .rectusAbdominis]
        case .hackSquat:
            [.adductorMagnus, .rectusAbdominis]
        case .sissySquat:
            [.vastusLateralis, .vastusMedialis]
        case .legExtensions:
            [.vastusLateralis, .vastusMedialis]
        case .legCurls:
            [.gluteusMaximus, .gracilis]
        case .romanianDeadlifts:
            [.adductorMagnus, .thoracolumbarFascia]
        case .nordicCurls:
            [.gluteusMaximus, .semitendinosus]
        case .gluteHamRaises:
            [.semitendinosus, .rectusAbdominis]
        case .cableHipAdduction:
            [.rectusFemoris, .sartorius]
        case .sideLyingAdductorRaises:
            [.tensorFasciaeLatae]
        case .copenhagenPlank:
            [.rectusAbdominis, .externalObliques]
        case .sideLyingLegRaises:
            [.gluteusMaximus]
        case .clamshells:
            [.tensorFasciaeLatae, .gluteusMaximus]
        case .resistanceBandLateralWalks:
            [.gluteusMaximus, .rectusFemoris]
        case .calfRaises:
            [.soleus]
        case .toeRaises:
            [.gastrocnemius]
        case .seatedCalfRaises:
            [.gastrocnemius]
        case .standingCalfRaises:
            [.soleus]
        case .donkeyCalfRaises:
            [.soleus]

            // MARK: - Calisthenics
        case .planche:
            [.latissimusDorsi, .gluteusMaximus, .externalObliques]
        case .muscleUps:
            [.triceps, .pectoralisMajor] // Triceps and chest for dip phase
        case .frontLever:
            [.biceps, .externalObliques] // Biceps and obliques stabilize
        case .backLever:
            [.triceps, .externalObliques] // Triceps and obliques assist
        case .humanFlag:
            [.rectusAbdominis, .externalObliques] // Core and upper back stabilize
        }
    }
}

//
//  MuscleGroup+Localizable.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/21/25.
//

import SwiftUI

extension MuscleGroup {
    var commonName: String {
        switch self {
        case .adductors: return "Adductors".localized
        case .biceps: return "Biceps".localized
        case .brachialis: return "Brachialis".localized
        case .brachioradialis: return "Brachioradialis".localized
        case .deltoids: return "Shoulders".localized
        case .extensorCarpiRadialis: return "Forearm Extensors".localized
        case .externalObliques: return "Obliques".localized
        case .flexorCarpiRadialis: return "Forearm Flexors".localized
        case .gastrocnemius: return "Calf".localized
        case .omohyoid: return "Neck".localized
        case .pectoralisMajor: return "Chest".localized
        case .peroneusLongus: return "Outer Calf".localized
        case .rectusAbdominisLower: return "Lower Abs".localized
        case .rectusAbdominis: return "Abs".localized
        case .rectusFemoris: return "Quads".localized
        case .sartorius: return "Inner Thigh".localized
        case .serratusAnterior: return "Serratus".localized
        case .soleus: return "Soleus".localized
        case .sternocleidomastoid: return "Neck".localized
        case .tensorFasciaeLatae: return "Outer Thigh".localized
        case .trapezius: return "Traps".localized
        case .triceps: return "Triceps".localized
        case .vastusLateralis: return "Outer Quad".localized
        case .vastusMedialis: return "Inner Quad".localized
        case .adductorMagnus: return "Adductors".localized
        case .bicepsFemoris: return "Hamstrings".localized
        case .flexorCarpiUlnaris: return "Forearm Flexors".localized
        case .gluteusMaximus: return "Glutes".localized
        case .gluteusMedius: return "Glutes".localized
        case .gracilis: return "Groin".localized
        case .infraspinatus: return "Rotator Cuff".localized
        case .latissimusDorsi: return "Lats".localized
        case .lowerTrapezius: return "Lower Traps".localized
        case .rhomboidMajor: return "Rhomboids".localized
        case .semitendinosus: return "Hamstrings".localized
        case .teresMajor: return "Teres".localized
        case .thoracolumbarFascia: return "Lower Back".localized
        @unknown default:
            fatalError("Unsupported muscle group")
        }
    }

    var commonNameLocalized: String {
        return NSLocalizedString(commonName, comment: .empty)
    }
}

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
        case .adductors: "Adductors"
        case .biceps: "Biceps"
        case .brachialis: "Brachialis"
        case .brachioradialis: "Brachioradialis"
        case .deltoids: "Shoulders"
        case .extensorCarpiRadialis: "Forearm Extensors"
        case .externalObliques: "Obliques"
        case .flexorCarpiRadialis: "Forearm Flexors"
        case .gastrocnemius: "Calf"
        case .omohyoid: "Neck"
        case .pectoralisMajor: "Chest"
        case .peroneusLongus: "Outer Calf"
        case .rectusAbdominisLower: "Lower Abs"
        case .rectusAbdominis: "Abs"
        case .rectusFemoris: "Quads"
        case .sartorius: "Inner Thigh"
        case .serratusAnterior: "Serratus"
        case .soleus: "Soleus"
        case .sternocleidomastoid: "Neck"
        case .tensorFasciaeLatae: "Outer Thigh"
        case .trapezius: "Traps"
        case .triceps: "Triceps"
        case .vastusLateralis: "Outer Quad"
        case .vastusMedialis: "Inner Quad"
        case .adductorMagnus: "Adductors"
        case .bicepsFemoris: "Hamstrings"
        case .flexorCarpiUlnaris: "Forearm Flexors"
        case .gluteusMaximus: "Glutes"
        case .gluteusMedius: "Glutes"
        case .gracilis: "Groin"
        case .infraspinatus: "Rotator Cuff"
        case .latissimusDorsi: "Lats"
        case .lowerTrapezius: "Lower Traps"
        case .rhomboidMajor: "Rhomboids"
        case .semitendinosus: "Hamstrings"
        case .teresMajor: "Teres"
        case .thoracolumbarFascia: "Lower Back"
        @unknown default:
            fatalError("Unsupported muscle group")
        }
    }

    var commonNameLocalized: String {
        return NSLocalizedString(commonName, comment: .empty)
    }
}

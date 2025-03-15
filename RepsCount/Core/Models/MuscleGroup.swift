//
//  MuscleGroup.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/15/25.
//

public enum MuscleGroup: String, CaseIterable, Identifiable {
    case adductors
    case biceps
    case brachialis
    case brachioradialis
    case deltoids
    case extensorCarpiRadialis
    case externalObliques
    case flexorCarpiRadialis
    case gastrocnemius
    case omohyoid
    case pectoralisMajor
    case peroneusLongus
    case rectusAbdominisLower
    case rectusAbdominis
    case rectusFemoris
    case sartorius
    case serratusAnterior
    case soleus
    case sternocleidomastoid
    case tensorFasciaeLatae
    case trapezius
    case tricepsLongHead
    case tricepsMedialHead
    case vastusLateralis
    case vastusMedialis
    case adductorMagnus
    case bicepsFemoris
    case flexorCarpiUlnaris
    case gastrocnemiusLateralHead
    case gastrocnemiusMedialHead
    case gluteusMaximus
    case gluteusMedius
    case gracilis
    case infraspinatus
    case latissimusDorsi
    case lowerTrapezius
    case rhomboidMajor
    case semitendinosus
    case teresMajor
    case thoracolumbarFascia
    case tricepsLongLateralHead

    public var id: String { rawValue }

    public var latinName: String {
        switch self {
        case .adductors: "Adductor Longus and Pectineus"
        case .biceps: "Biceps Brachii"
        case .brachialis: "Brachialis"
        case .brachioradialis: "Brachioradialis"
        case .deltoids: "Deltoids"
        case .extensorCarpiRadialis: "Extensor Carpi Radialis"
        case .externalObliques: "External Obliques"
        case .flexorCarpiRadialis: "Flexor Carpi Radialis"
        case .gastrocnemius: "Gastrocnemius (Calf)"
        case .omohyoid: "Omohyoid"
        case .pectoralisMajor: "Pectoralis Major"
        case .peroneusLongus: "Peroneus Longus"
        case .rectusAbdominisLower: "Rectus Abdominus (Lower)"
        case .rectusAbdominis: "Rectus Abdominus"
        case .rectusFemoris: "Rectus Femoris"
        case .sartorius: "Sartorius"
        case .serratusAnterior: "Serratus Anterior"
        case .soleus: "Soleus"
        case .sternocleidomastoid: "Sternocleidomastoid"
        case .tensorFasciaeLatae: "Tensor Fasciae Latae"
        case .trapezius: "Trapezius"
        case .tricepsLongHead: "Triceps Brachii, Long Head"
        case .tricepsMedialHead: "Triceps Brachii, Medial Head"
        case .vastusLateralis: "Vastus Lateralis"
        case .vastusMedialis: "Vastus Medialis"
        case .adductorMagnus: "Adductor Magnus"
        case .bicepsFemoris: "Biceps Femoris"
        case .flexorCarpiUlnaris: "Flexor Carpi Ulnaris"
        case .gastrocnemiusLateralHead: "Gastrocnemius, Lateral Head"
        case .gastrocnemiusMedialHead: "Gastrocnemius, Medial Head"
        case .gluteusMaximus: "Gluteus Maximus"
        case .gluteusMedius: "Gluteus Medius"
        case .gracilis: "Gracilis"
        case .infraspinatus: "Infraspinatus"
        case .latissimusDorsi: "Latissimus Dorsi"
        case .lowerTrapezius: "Lower Trapezius"
        case .rhomboidMajor: "Rhomboid Major"
        case .semitendinosus: "Semitendinosus"
        case .teresMajor: "Teres Major"
        case .thoracolumbarFascia: "Thoracolumbar Fascia"
        case .tricepsLongLateralHead: "Triceps Brachii (Long Head, Lateral Head)"
        }
    }
}


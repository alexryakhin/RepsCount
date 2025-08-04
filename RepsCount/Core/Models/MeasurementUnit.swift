//
//  MeasurementUnit.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/28/24.
//

import Foundation
import struct SwiftUI.LocalizedStringKey

enum MeasurementUnit: Int, CaseIterable {
    case kilograms
    case pounds
    case stones

    var title: LocalizedStringKey {
        switch self {
        case .kilograms: "Kilograms"
        case .pounds: "Pounds"
        case .stones: "Stones"
        }
    }

    var shortName: LocalizedStringKey {
        switch self {
        case .kilograms: "kg"
        case .pounds: "lb"
        case .stones: "st"
        }
    }

    var unitMass: UnitMass {
        switch self {
        case .kilograms: return .kilograms
        case .pounds: return .pounds
        case .stones: return .stones
        }
    }

    func convertToKilograms(_ value: Double) -> Measurement<UnitMass> {
        let m = Measurement(value: value, unit: unitMass)
        return m.converted(to: .kilograms)
    }

    func convertTo(_ value: Double, unit: MeasurementUnit) -> Measurement<UnitMass> {
        let m = Measurement(value: value, unit: unitMass)
        return m.converted(to: unit.unitMass)
    }

    func convertFromKilograms(_ value: Double) -> Measurement<UnitMass> {
        let m = Measurement(value: value, unit: UnitMass.kilograms)
        return m.converted(to: unitMass)
    }

    func convertFromKilograms(_ value: Double) -> String {
        let measurement = Measurement(value: value, unit: UnitMass.kilograms)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.unitOptions = .providedUnit

        return formatter.string(from: measurement.converted(to: unitMass))
    }
}

//
//  MeasurementUnit.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/28/24.
//

import Foundation
import SwiftUI

enum MeasurementUnit: Int, CaseIterable {
    case kilograms
    case pounds
    case stones

    var title: String {
        switch self {
        case .kilograms: return LocalizationKeys.Units.kilograms
        case .pounds: return LocalizationKeys.Units.pounds
        case .stones: return LocalizationKeys.Units.st
        }
    }

    var shortName: String {
        switch self {
        case .kilograms: return LocalizationKeys.Units.kg
        case .pounds: return LocalizationKeys.Units.lb
        case .stones: return LocalizationKeys.Units.st
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

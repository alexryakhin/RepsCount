//
//  NumberFormatter+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation

extension NumberFormatter {

    func percentString(value: Double) -> String {
        let formatter = self
        formatter.numberStyle = .percent
        return formatter.string(for: value)!
    }
}

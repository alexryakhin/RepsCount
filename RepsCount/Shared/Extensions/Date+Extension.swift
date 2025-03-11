//
//  Date+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/19/25.
//

import Foundation

public extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

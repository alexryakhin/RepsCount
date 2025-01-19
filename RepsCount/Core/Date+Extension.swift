//
//  Date+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/19/25.
//

import Foundation

extension Date {
    func trimmed(_ components: Set<Calendar.Component> = [.year, .month, .day]) -> Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents(components, from: self))!
    }
}

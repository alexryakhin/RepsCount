//
//  TimeInterval+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/18/25.
//

import Foundation

public extension TimeInterval {
    /// Converts the time interval into hours.
    var hour: Int {
        let division = self / 3600
        return Int((division).truncatingRemainder(dividingBy: 3600))
    }

    /// Converts the time interval into minutes.
    var minute: Int {
        let division = self / 60
        return Int((division).truncatingRemainder(dividingBy: 60))
    }

    /// Specifies the hour and minutes of the current date.
    var toTodayDate: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date.now)
        components.hour = self.hour
        components.minute = self.minute
        return Calendar.current.date(from: components) ?? Date()
    }

    /// Formats the time interval into specified units.
    func formatted(with allowedUnits: NSCalendar.Unit, unitsStyle: DateComponentsFormatter.UnitsStyle = .short) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = unitsStyle
        formatter.allowedUnits = allowedUnits
        return formatter.string(from: self) ?? "-"
    }
}

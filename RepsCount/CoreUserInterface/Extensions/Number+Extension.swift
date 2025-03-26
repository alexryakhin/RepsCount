//
//  Number+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/26/25.
//

public extension Int {
    var repsCountLocalized: String {
        let repsCountFormat = NSLocalizedString("%d reps", comment: .empty)
        let repsCountString = String.localizedStringWithFormat(repsCountFormat, self)
        return repsCountString
    }

    var repsCountShortLocalized: String {
        let repsCountFormat = NSLocalizedString("%d reps short", comment: .empty)
        let repsCountString = String.localizedStringWithFormat(repsCountFormat, self)
        return repsCountString
    }

    var setsCountLocalized: String {
        let setsCountFormat = NSLocalizedString("%d sets", comment: .empty)
        let setsCountString = String.localizedStringWithFormat(setsCountFormat, self)
        return setsCountString
    }
}

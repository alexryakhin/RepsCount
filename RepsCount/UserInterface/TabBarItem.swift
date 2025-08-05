//
//  TabBarItem.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation
import UIKit

enum TabBarItem {
    case today
    case fitness
    case planning
    case settings

    var title: String {
        switch self {
        case .today: "Today"
        case .fitness: "Fitness"
        case .planning: "Planning"
        case .settings: "Settings"
        }
    }

    var localizedTitle: String {
        NSLocalizedString(title, comment: title)
    }

    var icon: String {
        switch self {
        case .today: "doc.text.image"
        case .fitness: "chart.line.uptrend.xyaxis"
        case .planning: "figure.run.square.stack"
        case .settings: "gearshape"
        }
    }
}

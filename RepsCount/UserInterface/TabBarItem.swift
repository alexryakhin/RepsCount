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
    case planning
    case settings

    var title: String {
        switch self {
        case .today: "Today"
        case .planning: "Planning"
        case .settings: "Settings"
        }
    }

    var localizedTitle: String {
        NSLocalizedString(title, comment: title)
    }

    var image: String {
        switch self {
        case .today: "doc.text.image"
        case .planning: "figure.run.square.stack"
        case .settings: "gearshape"
        }
    }

    var selectedImage: String {
        switch self {
        case .today: "doc.text.image.fill"
        case .planning: "figure.run.square.stack.fill"
        case .settings: "gearshape.fill"
        }
    }

    var item: UITabBarItem {
        UITabBarItem(
            title: localizedTitle,
            image: .init(systemName: image),
            selectedImage: .init(systemName: selectedImage)
        )
    }
}

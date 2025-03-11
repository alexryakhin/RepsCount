//
//  TabBarItem.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation
import UIKit

public enum TabBarItem {
    case exercises
    case calendar
    case more

    public var title: String {
        switch self {
        case .exercises: "Exercises"
        case .calendar: "Calendar"
        case .more: "More"
        }
    }

    public var image: String {
        switch self {
        case .exercises: "dumbbell"
        case .calendar: "calendar"
        case .more: "ellipsis.circle"
        }
    }

    public var selectedImage: String {
        switch self {
        case .exercises: "dumbbell.fill"
        case .calendar: "calendar"
        case .more: "ellipsis.circle.fill"
        }
    }

    public var item: UITabBarItem {
        UITabBarItem(
            title: title,
            image: .init(systemName: image),
            selectedImage: .init(systemName: selectedImage)
        )
    }
}

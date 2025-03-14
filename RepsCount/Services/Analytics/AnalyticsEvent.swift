//
//  AnalyticsEvent.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/25/25.
//

import Foundation
import Shared

public enum AnalyticsEvent {
    case appOpened
    case exercisesListOpened
    case moreOpened

    case addExerciseTapped

    case buyMeACoffeeTapped
    case twitterButtonTapped
    case instagramButtonTapped

    var rawValue: String {
        switch self {
        case .appOpened: "appOpened"
        case .exercisesListOpened: "exercisesListOpened"
        case .moreOpened: "moreOpened"
        case .addExerciseTapped: "addExerciseTapped"
        case .buyMeACoffeeTapped: "buyMeACoffeeTapped"
        case .twitterButtonTapped: "twitterButtonTapped"
        case .instagramButtonTapped: "instagramButtonTapped"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .appOpened:
            ["version": GlobalConstant.currentFullAppVersion]
        default:
            nil
        }
    }
}

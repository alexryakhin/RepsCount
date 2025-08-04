//
//  GlobalConstant.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import UIKit

enum GlobalConstant {

    static var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    static var buildVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

    static var currentFullAppVersion: String {
        String(appVersion ?? "-", buildVersion ?? "–", separator: ".")
    }

    static var buyMeACoffeeUrl: URL {
        URL(string: "https://buymeacoffee.com/xander1100001")!
    }

    static var twitterUrl: URL {
        URL(string: "https://x.com/xander1100001")!
    }

    static var instagramUrl: URL {
        URL(string: "https://www.instagram.com/ar_x101")!
    }
}

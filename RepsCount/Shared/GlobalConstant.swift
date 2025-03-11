//
//  GlobalConstant.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import UIKit

public enum GlobalConstant {

    public static var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    public static var buildVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

    public static var currentFullAppVersion: String {
        String(appVersion ?? "-", buildVersion ?? "–", separator: ".")
    }

    public static var buyMeACoffeeUrl: URL {
        URL(string: "https://buymeacoffee.com/xander1100001")!
    }

    public static var twitterUrl: URL {
        URL(string: "https://x.com/xander1100001")!
    }

    public static var instagramUrl: URL {
        URL(string: "https://www.instagram.com/ar_x101")!
    }
}

//
//  GlobalConstants.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/28/24.
//

import Foundation
import UIKit
import SwiftUI

public enum GlobalConstant {

    public static var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    public static var buildVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

    public static var currentFullAppVersion: String {
        String(GlobalConstant.appVersion ?? "-", GlobalConstant.buildVersion ?? "–", separator: ".")
    }
}

//
//  GlobalConstants.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/28/24.
//

import Foundation
import UIKit
import SwiftUI

enum GlobalConstant {

    static var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    static var buildVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

    static var currentFullAppVersion: String {
        String(GlobalConstant.appVersion ?? "-", GlobalConstant.buildVersion ?? "–", separator: ".")
    }
}

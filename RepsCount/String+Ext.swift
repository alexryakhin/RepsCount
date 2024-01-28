//
//  String+Ext.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/28/24.
//

import Foundation

extension String {
    init(_ substrings: String?..., separator: String = "") {
        self = substrings.compactMap { $0 }.joined(separator: separator)
    }

    init(_ substrings: [String?], separator: String = "") {
        self = substrings.compactMap { $0 }.joined(separator: separator)
    }

    static func join(_ substrings: [String?], separator: String = "") -> String {
        return String(substrings, separator: separator)
    }

    static func join(_ substrings: String?..., separator: String = "") -> String {
        return String(substrings, separator: separator)
    }
}

//
//  Int+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation

extension Numeric {
    @inlinable func `if`(_ condition: Bool, transform: (Self) -> Self) -> Self {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    var nilIfZero: Self? {
        self == 0 ? nil : self
    }
}

extension Int64 {
    var int: Int {
        Int(self)
    }
}

extension Int {
    var int64: Int64 {
        Int64(self)
    }
}


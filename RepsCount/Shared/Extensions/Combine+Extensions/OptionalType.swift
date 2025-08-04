//
//  OptionalType.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/9/25.
//

import Combine

protocol OptionalType {
    
    associatedtype Wrapped

    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    
    var value: Wrapped? {
        return self
    }
}

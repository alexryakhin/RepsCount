//
//  Location.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/12/25.
//
import Foundation

public struct Location: Hashable {
    public let latitude: Double
    public let longitude: Double
    public let address: String?

    public init(
        latitude: Double,
        longitude: Double,
        address: String?
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}

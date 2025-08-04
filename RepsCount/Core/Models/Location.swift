//
//  Location.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/12/25.
//
import Foundation

struct Location: Hashable {
    let latitude: Double
    let longitude: Double
    let address: String?

    init(
        latitude: Double,
        longitude: Double,
        address: String?
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
}

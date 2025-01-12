//
//  LocationManager.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/27/24.
//

import Foundation
import CoreLocation

struct Location {
    var latitude: Double
    var longitude: Double
    var address: String?
}

protocol LocationManagerInterface: AnyObject {
    func initiateLocationManager()
    func getCurrentLocation() async -> Location?
}

class LocationManager: NSObject, LocationManagerInterface, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    func initiateLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
    }

    func getCurrentLocation() async -> Location? {
        locationManager.startUpdatingLocation()
        guard let currentLocation = locationManager.location else {
            locationManager.stopUpdatingLocation()
            return nil
        }
        let location = Location(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude,
            address: await getAddress(for: currentLocation)
        )
        locationManager.stopUpdatingLocation()
        return location
    }
    
    private func getAddress(for location: CLLocation) async -> String? {
        let placemarks = try? await CLGeocoder().reverseGeocodeLocation(location)
        guard let pm = placemarks?.first else { return nil }
        var addressComponents: [String] = []
        if let street = pm.thoroughfare {
            addressComponents.append(street)
        }
        if let building = pm.subThoroughfare {
            addressComponents.append(building)
        }
        if let city = pm.locality {
            addressComponents.append(city)
        }
        if let country = pm.country {
            addressComponents.append(country)
        }
        return addressComponents.isEmpty ? nil : addressComponents.joined(separator: ", ")
    }
}

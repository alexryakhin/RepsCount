//
//  LocationManager.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/27/24.
//

import Foundation
import CoreLocation
import Core
import Combine

public protocol LocationManagerInterface: AnyObject {
    /// Specifies the authorization status for the app.
    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> { get }

    func requestAccess()
    func getCurrentLocation() async throws(CoreError) -> Location?
}

public final class LocationManager: NSObject, LocationManagerInterface, CLLocationManagerDelegate {

    /// Specifies the authorization status for the app.
    public var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationStatusSubject.eraseToAnyPublisher()
    }

    private let locationManager = CLLocationManager()
    private let authorizationStatusSubject = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)

    public override init() {
        super.init()
        authorizationStatusSubject.value = locationManager.authorizationStatus
        initiateLocationManager()
    }

    public func requestAccess() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func getCurrentLocation() async throws(CoreError) -> Location? {
        try verifyAuthorizationStatus()
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

    private func initiateLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
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

    /// Verifies the authorization status for the app.
    private func verifyAuthorizationStatus() throws(CoreError) {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            requestAccess()
        case .restricted:
            throw CoreError.eventStoreError(.restricted)
        case .denied:
            throw CoreError.eventStoreError(.denied)
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            throw CoreError.eventStoreError(.unknown)
        }
    }
}

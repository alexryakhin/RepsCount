//
//  MapView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/2/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    let location: CLLocationCoordinate2D
    @State private var region: MKCoordinateRegion

    init(location: CLLocationCoordinate2D) {
        self.location = location
        _region = State(initialValue: MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        ))
    }

    var body: some View {
        Map(position: .constant(.region(region))) {
            Marker("Workout Location", coordinate: location)
        }
        .frame(height: 200)
        .allowsHitTesting(false)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .clipped()
    }
}

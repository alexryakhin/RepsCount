//
//  MapView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/2/25.
//

import SwiftUI
import MapKit

public struct MapView: View {
    private let location: CLLocationCoordinate2D
    @State private var snapshotImage: UIImage?
    @State private var viewWidth: CGFloat = 300  // Default width in case GeometryReader is not applied

    public init(location: CLLocationCoordinate2D) {
        self.location = location
    }

    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = width * 0.66  // Maintain aspect ratio

            Group {
                if let snapshotImage = snapshotImage {
                    Image(uiImage: snapshotImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: height)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            Image(systemName: "mappin.and.ellipse")
                        }
                } else {
                    ShimmerView(width: width, height: height)
                        .onAppear {
                            takeSnapshot(width: width, height: height)
                        }
                }
            }
            .onAppear {
                viewWidth = width  // Store width for snapshot updates
            }
        }
        .frame(height: viewWidth * 0.66)  // Set height dynamically
    }

    private func takeSnapshot(width: CGFloat, height: CGFloat) {
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        options.size = CGSize(width: width, height: height)
        options.scale = UIScreen.main.scale

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot else { return }
            DispatchQueue.main.async {
                snapshotImage = snapshot.image
            }
        }
    }
}

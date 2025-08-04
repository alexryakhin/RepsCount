//
//  MapView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/2/25.
//

import SwiftUI
import MapKit

struct MapView: View {

    @Environment(\.colorScheme) var colorScheme

    private let location: CLLocationCoordinate2D
    @State private var snapshotImage: UIImage?
    @State private var viewWidth: CGFloat = 300  // Default width in case GeometryReader is not applied
    private static let cache = NSCache<NSString, UIImage>()

    init(location: CLLocationCoordinate2D) {
        self.location = location
    }

    var body: some View {
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
                            Image(.mapMarker)
                                .frame(sideLength: 30)
                        }
                } else {
                    ShimmerView(width: width, height: height)
                }
            }
            .onAppear {
                viewWidth = width  // Store width for snapshot updates
            }
            .task(id: colorScheme, priority: .userInitiated) {
                await takeSnapshot(width: width, height: height)
            }
        }
        .frame(height: viewWidth * 0.66)  // Set height dynamically
    }

    private func takeSnapshot(width: CGFloat, height: CGFloat) async {
        let key = "\(location.latitude),\(location.longitude),\(Int(width)),\(colorScheme)" as NSString

        if let cached = MapView.cache.object(forKey: key) {
            self.snapshotImage = cached
            return
        }

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
                MapView.cache.setObject(snapshot.image, forKey: key)
                self.snapshotImage = snapshot.image
            }
        }
    }
}

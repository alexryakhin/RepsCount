//
//  MuscleMapImageView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/15/25.
//

import SwiftUI
import Core

public struct MuscleMapImageView: View {

    @Environment(\.colorScheme) var colorScheme

    private static let imageCache = NSCache<NSString, UIImage>()

    enum ColorStyle {
        case primary
        case secondary
        case notInvolved
        case background

        var color: Color {
            switch self {
            case .primary:
                Color.primaryMuscleGroup
            case .secondary:
                Color.secondaryMuscleGroup
            case .notInvolved:
                Color.quaternarySystemFill
            case .background:
                Color.background
            }
        }
    }

    private let width: CGFloat

    private let primaryMuscleGroups: [MuscleGroup]
    private let secondaryMuscleGroups: [MuscleGroup]

    @State private var frontImage: Image?
    @State private var backImage: Image?

    public init(
        primaryMuscleGroups: [MuscleGroup],
        secondaryMuscleGroups: [MuscleGroup],
        width: CGFloat = 60
    ) {
        self.primaryMuscleGroups = primaryMuscleGroups
        self.secondaryMuscleGroups = secondaryMuscleGroups
        self.width = width
    }

    public init(exercises: [ExerciseModel], width: CGFloat = 60) {
        let allPrimary = exercises.flatMap { $0.primaryMuscleGroups }
        let allSecondary = exercises.flatMap { $0.secondaryMuscleGroups }
        self.init(
            primaryMuscleGroups: Array(Set(allPrimary)),
            secondaryMuscleGroups: Array(Set(allSecondary)),
            width: width
        )
    }

    public init(exercise: ExerciseModel, width: CGFloat = 60) {
        self.init(
            primaryMuscleGroups: Array(Set(exercise.primaryMuscleGroups)),
            secondaryMuscleGroups: Array(Set(exercise.secondaryMuscleGroups)),
            width: width
        )
    }

    public var body: some View {
        HStack(spacing: 8) {
            if let frontImage, let backImage {
                frontImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, alignment: .center)

                backImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ZStack {
                    Color.background
                    ProgressView()
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .task(id: UUID(), priority: .userInitiated) {
            async let frontImage = renderMuscleMap(svgName: "front")
            async let backImage = renderMuscleMap(svgName: "back")
            self.frontImage = await Image(uiImage: frontImage)
            self.backImage = await Image(uiImage: backImage)
        }
    }

    @ViewBuilder
    private func background(for shape: PathData) -> some View {
        let style: ColorStyle = if primaryMuscleGroups.contains(where: { group in
            group.id == shape.name
        }) {
            .primary
        } else if secondaryMuscleGroups.contains(where: { group in
            group.id == shape.name
        }) {
            .secondary
        } else if shape.name == "background" {
            .background
        } else {
            .notInvolved
        }
        InteractiveShape(shape)
            .fill(style.color)
    }

    private func renderMuscleMap(svgName: String) async -> UIImage {
        let primaryMuscleGroups: String = primaryMuscleGroups.map(\.rawValue).joined(separator: ";")
        let secondaryMuscleGroups: String = secondaryMuscleGroups.map(\.rawValue).joined(separator: ";")
        let key = "Primary: \(primaryMuscleGroups)| Secondary: \(secondaryMuscleGroups), svgName: \(svgName), width: \(width), colorScheme: \(colorScheme)"
        if let cached = MuscleMapImageView.imageCache.object(forKey: key as NSString) {
            return cached
        }

        let muscleMap = InteractiveMap(svgName: svgName) { shape in
            InteractiveShape(shape)
                .stroke(Color.accentColor, lineWidth: 1)
                .background(background(for: shape))
        }
        .padding(1)
        .environment(\.colorScheme, colorScheme == .light ? .light : .dark)

        let renderer = ImageRenderer(content: muscleMap)
        renderer.proposedSize = .init(width: width, height: width / 0.35)
        renderer.scale = UIScreen.main.scale

        if let uiImage = renderer.uiImage {
            MuscleMapImageView.imageCache.setObject(uiImage, forKey: key as NSString)
            return uiImage
        } else {
            return UIImage()
        }
    }
}

//
//  MuscleMapView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/15/25.
//

import SwiftUI
import Core

public struct MuscleMapView: View {

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

    private let primaryMuscleGroups: [MuscleGroup]
    private let secondaryMuscleGroups: [MuscleGroup]

    public init(primaryMuscleGroups: [MuscleGroup], secondaryMuscleGroups: [MuscleGroup]) {
        self.primaryMuscleGroups = primaryMuscleGroups
        self.secondaryMuscleGroups = secondaryMuscleGroups
    }

    public init(exercises: [any ExerciseModel]) {
        let allPrimary = exercises.flatMap { $0.primaryMuscleGroups }
        let allSecondary = exercises.flatMap { $0.secondaryMuscleGroups }
        self.init(primaryMuscleGroups: Array(Set(allPrimary)), secondaryMuscleGroups: Array(Set(allSecondary)))
    }

    public var body: some View {
        HStack(spacing: 8) {
            InteractiveMap(svgName: "front") { shape in
                InteractiveShape(shape)
                    .stroke(Color.accentColor)
                    .background(background(for: shape))
                    .onTapGesture {
                        print("DEBUG50 - tapped \(shape.name)")
                    }
            }
            .aspectRatio(0.35, contentMode: .fit)
            .frame(maxWidth: .infinity, alignment: .center)

            InteractiveMap(svgName: "back") { shape in
                InteractiveShape(shape)
                    .stroke(Color.accentColor)
                    .background(background(for: shape))
                    .onTapGesture {
                        print("DEBUG50 - tapped \(shape.name)")
                    }
            }
            .aspectRatio(0.35, contentMode: .fit)
            .frame(maxWidth: .infinity, alignment: .center)
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
}

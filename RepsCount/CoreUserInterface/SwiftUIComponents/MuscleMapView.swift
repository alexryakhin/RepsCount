//
//  MuscleMapView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/15/25.
//

import SwiftUI
import Core

public struct MuscleMapView: View {

    private let primaryMuscleGroups: [MuscleGroup]
    private let secondaryMuscleGroups: [MuscleGroup]

    public init(primaryMuscleGroups: [MuscleGroup], secondaryMuscleGroups: [MuscleGroup]) {
        self.primaryMuscleGroups = primaryMuscleGroups
        self.secondaryMuscleGroups = secondaryMuscleGroups
    }

    public init(exercises: [ExerciseModel]) {
        // TODO: init
        self.init(primaryMuscleGroups: [], secondaryMuscleGroups: [])
    }

    public var body: some View {
        HStack(spacing: 8) {
            InteractiveMap(svgName: "front") { shape in
                InteractiveShape(shape)
                    .stroke(Color.cyan)
                    .shadow(color: .cyan, radius: 3, x: 0, y: 0)
                    .background(InteractiveShape(shape).fill(Color.black))
                    .onTapGesture {
                        print("DEBUG50 - tapped \(shape.name)")
                    }
            }
            .aspectRatio(0.35, contentMode: .fit)

            InteractiveMap(svgName: "back") { shape in
                InteractiveShape(shape)
                    .stroke(Color.cyan)
                    .shadow(color: .cyan, radius: 3, x: 0, y: 0)
                    .background(InteractiveShape(shape).fill(Color.black))
                    .onTapGesture {
                        print("DEBUG50 - tapped \(shape.name)")
                    }
            }
            .aspectRatio(0.35, contentMode: .fit)
        }
        .clippedWithBackground(Color.systemBackground)
    }
}

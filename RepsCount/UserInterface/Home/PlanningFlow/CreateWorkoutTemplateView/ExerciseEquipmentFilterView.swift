//
//  ExerciseEquipmentFilterView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

import SwiftUI

struct ExerciseEquipmentFilterView: View {
    @Binding var selectedEquipment: Set<ExerciseEquipment>
    
    var body: some View {
        Menu {
            ForEach(ExerciseEquipment.allCases, id: \.self) { equipment in
                Button {
                    guard equipment != .none else { return }

                    if selectedEquipment.contains(equipment) {
                        selectedEquipment.remove(equipment)
                    } else {
                        selectedEquipment.insert(equipment)
                    }
                    AnalyticsService.shared.logEvent(.addExerciseScreenEquipmentChanged)
                } label: {
                    Label(equipment.localizedName, systemImage: selectedEquipment.contains(equipment) ? "checkmark.circle.fill" : "circle")
                }
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }
}

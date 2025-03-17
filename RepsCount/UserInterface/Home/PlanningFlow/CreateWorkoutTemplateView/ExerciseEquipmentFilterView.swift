//
//  ExerciseEquipmentFilterView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/16/25.
//

import Core
import SwiftUI

struct ExerciseEquipmentFilterView: View {
    @Binding var selectedEquipment: Set<ExerciseEquipment>
    
    var body: some View {
        Menu {
            ForEach(ExerciseEquipment.allCases, id: \.self) { equipment in
                Button(action: {
                    guard equipment != .none else { return }

                    if selectedEquipment.contains(equipment) {
                        selectedEquipment.remove(equipment)
                    } else {
                        selectedEquipment.insert(equipment)
                    }
                }) {
                    Label(equipment.rawValue, systemImage: selectedEquipment.contains(equipment) ? "checkmark.circle.fill" : "circle")
                }
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }
}

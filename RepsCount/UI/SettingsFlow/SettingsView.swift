//
//  SettingsView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/28/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaultsKey.measurementUnit.rawValue) var measurementUnit: MeasurementUnit = .kilograms
    @AppStorage(UserDefaultsKey.savesLocation.rawValue) var savesLocation: Bool = true
    @AppStorage(UserDefaultsKey.showsFiltersOnExerciseList.rawValue) var showsFiltersOnExerciseList: Bool = true

    private let resolver = DIContainer.shared.resolver

    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(selection: $measurementUnit) {
                        ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                            Text(unit.title)
                        }
                    } label: {
                        Text("Measurement unit")
                    }

                    Toggle("Save location", isOn: $savesLocation)
                    Toggle("Show filters on exercise list", isOn: $showsFiltersOnExerciseList)

                    // TODO: edit exercises list
//                    Text("Edit exercises list")
                }

                Section {
                    NavigationLink {
                        resolver.resolve(AboutAppView.self)!
                    } label: {
                        Text("About app")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    DIContainer.shared.resolver.resolve(SettingsView.self)!
}

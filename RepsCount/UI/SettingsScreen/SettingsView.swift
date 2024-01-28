//
//  SettingsView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/28/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("measurementUnit") var measurementUnit: MeasurementUnit = .kilograms
    @AppStorage("savesLocation") var savesLocation: Bool = true

    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker(selection: $measurementUnit) {
                        ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                            Text(unit.title)
                        }
                    } label: {
                        Text("Choose a measurement unit")
                    }

                    Toggle("Save location", isOn: $savesLocation)
                }

                Section {
                    NavigationLink {
                        Text("About app")
                    } label: {
                        Text("About app")
                    }
                } footer: {
                    Text("Version: \(currentFullAppVersion)")
                }
            }
            .navigationTitle("Settings")
        }
    }

    var currentFullAppVersion: String {
        String(GlobalConstant.appVersion ?? "-", GlobalConstant.buildVersion ?? "–", separator: ".")
    }
}

#Preview {
    SettingsView()
}

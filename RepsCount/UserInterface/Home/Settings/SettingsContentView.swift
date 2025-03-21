import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core
import Shared
import UniformTypeIdentifiers
import StoreKit
import struct Services.AnalyticsService

public struct SettingsContentView: PageView {

    public typealias ViewModel = SettingsViewModel

    @AppStorage(UDKeys.measurementUnit) var measurementUnit: MeasurementUnit = .kilograms
    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        List {
            // MARK: - Settings

            Section {
                Picker(selection: $measurementUnit) {
                    ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                        Text(unit.title)
                    }
                } label: {
                    Text("Measurement unit")
                }

                Toggle("Save location", isOn: $viewModel.savesLocation)
            }

            // MARK: - About

            Section {
                Button("About app") {
                    viewModel.handle(.showAboutApp)
                }
            }
        }
        .listStyle(.insetGrouped)
        .onAppear {
            AnalyticsService.shared.logEvent(.settingsOpened)
        }
    }
}

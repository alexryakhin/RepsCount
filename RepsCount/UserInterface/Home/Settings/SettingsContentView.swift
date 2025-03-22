import SwiftUI
import CoreUserInterface
import Core
import Shared
import UniformTypeIdentifiers
import StoreKit
import struct Services.AnalyticsService

public struct SettingsContentView: PageView {

    public typealias ViewModel = SettingsViewModel

    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        List {
            // MARK: - Settings

            Section {
                Picker(selection: $viewModel.measurementUnit) {
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
                    AnalyticsService.shared.logEvent(.settingsScreenAboutAppButtonTapped)
                }
            }
        }
        .listStyle(.insetGrouped)
        .onAppear {
            AnalyticsService.shared.logEvent(.settingsScreenOpened)
        }
    }
}

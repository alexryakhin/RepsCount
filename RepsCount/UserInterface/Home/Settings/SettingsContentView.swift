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
    @State private var isShowingGoToSettingsAlert: Bool = false

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
                    Label("Measurement unit", systemImage: "lines.measurement.horizontal")

                }

                Toggle(isOn: $viewModel.savesLocation) {
                    Label("Save location", systemImage: "location.fill")
                }

                Button {
                    isShowingGoToSettingsAlert.toggle()
                    AnalyticsService.shared.logEvent(.settingsScreenLanguageButtonTapped)
                } label: {
                    Label("Change language", systemImage: "globe")
                }
            }

            // MARK: - About

            Section {
                Button {
                    viewModel.handle(.showAboutApp)
                    AnalyticsService.shared.logEvent(.settingsScreenAboutAppButtonTapped)
                } label: {
                    Label("About app", systemImage: "info")
                }
            }
        }
        .listStyle(.insetGrouped)
        .onAppear {
            AnalyticsService.shared.logEvent(.settingsScreenOpened)
        }
        .alert("Change language", isPresented: $isShowingGoToSettingsAlert) {
            Button("Cancel", role: .cancel) {
                AnalyticsService.shared.logEvent(.settingsScreenLanguageAlertCancelButtonTapped)
            }
            Button("Go to settings") {
                viewModel.handle(.showLanguageSettings)
                AnalyticsService.shared.logEvent(.settingsScreenLanguageAlertProceedButtonTapped)
            }
        } message: {
            Text("To change the language of the app, go to the Settings app on your device.")
        }
    }
}

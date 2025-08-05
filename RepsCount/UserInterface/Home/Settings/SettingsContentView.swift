import SwiftUI
import UniformTypeIdentifiers
import StoreKit

struct SettingsContentView: View {

    @ObservedObject var viewModel: SettingsViewModel
    @State private var isShowingGoToSettingsAlert: Bool = false

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            // MARK: - Settings

            Section {
                Picker(selection: $viewModel.measurementUnit) {
                    ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                        Text(unit.title)
                    }
                } label: {
                    Label(Loc.Settings.measurementUnit.localized, systemImage: "lines.measurement.horizontal")

                }

                Toggle(isOn: $viewModel.savesLocation) {
                    Label(Loc.Settings.saveLocation.localized, systemImage: "location.fill")
                }

                Button {
                    isShowingGoToSettingsAlert.toggle()
                    AnalyticsService.shared.logEvent(.settingsScreenLanguageButtonTapped)
                } label: {
                    Label(Loc.Settings.changeLanguage.localized, systemImage: "globe")
                }
            }

            // MARK: - About

            Section {
                Button {
                    viewModel.handle(.showAboutApp)
                    AnalyticsService.shared.logEvent(.settingsScreenAboutAppButtonTapped)
                } label: {
                    Label(Loc.Navigation.aboutApp.localized, systemImage: "info")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(Loc.Navigation.settings.localized)
        .additionalState(viewModel.additionalState)
        .withAlertManager()
        .onAppear {
            AnalyticsService.shared.logEvent(.settingsScreenOpened)
        }
        .alert(Loc.Settings.changeLanguage, isPresented: $isShowingGoToSettingsAlert) {
            Button(Loc.Common.cancel.localized, role: .cancel) {
                AnalyticsService.shared.logEvent(.settingsScreenLanguageAlertCancelButtonTapped)
            }
            Button(Loc.Settings.goToSettings.localized) {
                viewModel.handle(.showLanguageSettings)
                AnalyticsService.shared.logEvent(.settingsScreenLanguageAlertProceedButtonTapped)
            }
        } message: {
            Text(Loc.Settings.changeLanguageMessage)
        }
    }
}

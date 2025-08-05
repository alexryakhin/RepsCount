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
        ScrollView {
            LazyVStack(spacing: 20) {
                settingsSectionView
                aboutSectionView
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .navigationTitle(Loc.Navigation.settings.localized)
        .background(Color(.systemGroupedBackground))
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
    
    private var settingsSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Settings")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                // Measurement Unit
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "lines.measurement.horizontal")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Loc.Settings.measurementUnit.localized)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Choose your preferred unit system")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Picker("", selection: $viewModel.measurementUnit) {
                        ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                            Text(unit.title)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                )
                
                // Location Toggle
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Loc.Settings.saveLocation.localized)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Save workout location data")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $viewModel.savesLocation)
                        .labelsHidden()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                )
                
                // Language Button
                Button {
                    isShowingGoToSettingsAlert.toggle()
                    AnalyticsService.shared.logEvent(.settingsScreenLanguageButtonTapped)
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.1))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "globe")
                                .font(.title2)
                                .foregroundColor(.orange)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Loc.Settings.changeLanguage.localized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Change app language")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemGroupedBackground))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
                
                // HealthKit Permissions Button
                Button {
                    HealthKitPermissionService.shared.resetPermissionFlow()
                    HealthKitPermissionService.shared.shouldShowPermissionFlow = true
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.pink.opacity(0.1))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundColor(.pink)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("HealthKit Permissions")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Manage health data access")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemGroupedBackground))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }
    
    private var aboutSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("About")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Button {
                viewModel.handle(.showAboutApp)
                AnalyticsService.shared.logEvent(.settingsScreenAboutAppButtonTapped)
            } label: {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.purple.opacity(0.1))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "info")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Loc.Navigation.aboutApp.localized)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("App information and version")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                )
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
}

// MARK: - Button Styles

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

import Combine
import SwiftUI

final class SettingsViewModel: BaseViewModel {

    enum Input {
        case showAboutApp
        case showLanguageSettings
    }

    enum Output {
        case showAboutApp
    }

    let output = PassthroughSubject<Output, Never>()

    @AppStorage(UDKeys.savesLocation) var savesLocation: Bool = true {
        didSet {
            if savesLocation && !isLocationAccessAuthorized {
                locationManager.requestAccess()
            }
            if savesLocation {
                AnalyticsService.shared.logEvent(.settingsScreenSaveLocationTurnedOn)
            } else {
                AnalyticsService.shared.logEvent(.settingsScreenSaveLocationTurnedOff)
            }
        }
    }

    @AppStorage(UDKeys.measurementUnit) var measurementUnit: MeasurementUnit = .kilograms {
        didSet {
            AnalyticsService.shared.logEvent(.settingsScreenMeasurementUnitChanged)
        }
    }

    private let locationManager: LocationManagerInterface
    private var cancellables: Set<AnyCancellable> = []
    private var isLocationAccessAuthorized: Bool = false {
        didSet {
            if !isLocationAccessAuthorized {
                savesLocation = false
            }
        }
    }

    override init() {
        self.locationManager = ServiceManager.shared.locationManager
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .showAboutApp:
            output.send(.showAboutApp)
        case .showLanguageSettings:
            showLanguageSettings()
        }
    }

    private func setupBindings() {
        locationManager.authorizationStatusPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                self?.isLocationAccessAuthorized = (status == .authorizedWhenInUse || status == .authorizedAlways)
            }
            .store(in: &cancellables)
    }

    private func showLanguageSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

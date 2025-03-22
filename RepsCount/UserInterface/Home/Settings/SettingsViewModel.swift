import Core
import CoreUserInterface
import Services
import Shared
import Combine
import SwiftUI

public final class SettingsViewModel: DefaultPageViewModel {

    enum Input {
        case showAboutApp
    }

    enum Output {
        case showAboutApp
    }

    var onOutput: ((Output) -> Void)?

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

    public init(locationManager: LocationManagerInterface) {
        self.locationManager = locationManager
        super.init()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .showAboutApp:
            onOutput?(.showAboutApp)
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
}

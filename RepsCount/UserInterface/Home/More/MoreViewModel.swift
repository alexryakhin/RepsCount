import Core
import CoreUserInterface
import CoreNavigation
import Services
import Shared
import Combine
import SwiftUI

public final class MoreViewModel: DefaultPageViewModel {

    enum Input {
    }

    enum Output {
    }

    var onOutput: ((Output) -> Void)?

    @AppStorage(UDKeys.isShowingRating) var isShowingRating: Bool = true
    @AppStorage(UDKeys.savesLocation) var savesLocation: Bool = true {
        didSet {
            if savesLocation && !isLocationAccessAuthorized {
                locationManager.requestAccess()
            }
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

    private func setupBindings() {
        locationManager.authorizationStatusPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                self?.isLocationAccessAuthorized = (status == .authorizedWhenInUse || status == .authorizedAlways)
            }
            .store(in: &cancellables)
    }
}

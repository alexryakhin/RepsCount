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

    private var cancellables: Set<AnyCancellable> = []

    public init(arg: Int) {
        super.init()
        setupBindings()
    }

    private func setupBindings() {}
}

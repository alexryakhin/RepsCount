import SwiftUI
import CoreUserInterface
import Core
import StoreKit
import Shared
import struct Services.AnalyticsService

public struct AboutAppContentView: PageView {

    @Environment(\.requestReview) var requestReview

    public typealias ViewModel = AboutAppViewModel

    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: AboutAppViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        List {
            // MARK: - About

            Section {
                Text(NSLocalizedString("about_app_description_text", comment: .empty))
                    .multilineTextAlignment(.leading)
                HStack(spacing: 8) {
                    Text("App version:")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(GlobalConstant.currentFullAppVersion)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("About app")
            }

            // MARK: - Contact Me

            Section {
                Text(NSLocalizedString("contact_me_description_text", comment: .empty))
                Button {
                    UIApplication.shared.open(GlobalConstant.twitterUrl)
                    AnalyticsService.shared.logEvent(.twitterButtonTapped)
                } label: {
                    Label("X (Twitter)", systemImage: "bird")
                }
                Button {
                    UIApplication.shared.open(GlobalConstant.instagramUrl)
                    AnalyticsService.shared.logEvent(.instagramButtonTapped)
                } label: {
                    Label("Instagram", systemImage: "camera")
                }
            } header: {
                Text("Contact me")
            }

            // MARK: - Review section

            Section {
                Button {
                    UIApplication.shared.open(GlobalConstant.buyMeACoffeeUrl)
                    AnalyticsService.shared.logEvent(.buyMeACoffeeTapped)
                } label: {
                    Label("Buy Me a Coffee", systemImage: "cup.and.saucer.fill")
                        .foregroundColor(.orange)
                }
                if viewModel.isShowingRating {
                    Button {
                        requestReview()
                    } label: {
                        Label("Rate the app", systemImage: "star.fill")
                            .foregroundStyle(Color.yellow)
                    }
                }
            } header: {
                Text("Support")
            }
        }
        .listStyle(.insetGrouped)
        .onAppear {
            AnalyticsService.shared.logEvent(.aboutAppScreenOpened)
        }
    }
}

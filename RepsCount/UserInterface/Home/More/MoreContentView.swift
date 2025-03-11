import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core
import Shared
import UniformTypeIdentifiers
import StoreKit
import struct Services.AnalyticsService

public struct MoreContentView: PageView {

    @Environment(\.requestReview) var requestReview

    public typealias ViewModel = MoreViewModel

    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: MoreViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        List {
            // MARK: - About

            Section {
                Text("Welcome to Reps Counter, your companion for tracking and improving your workout performance!\n\nI created this app because I myself needed something simple yet powerful to track my progress, and it's pretty hard to do it just in Notes App.\n\nIf you like the app, please leave a review")
                    .multilineTextAlignment(.leading)
                HStack(spacing: 8) {
                    Text("App version:")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(GlobalConstant.currentFullAppVersion)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("About")
            }

            // MARK: - Follow Me

            Section {
                Text("Have questions, suggestions, or feedback? I'd love to hear from you. Reach out to get support on Instagram or X!")
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
            AnalyticsService.shared.logEvent(.moreOpened)
        }
    }
}

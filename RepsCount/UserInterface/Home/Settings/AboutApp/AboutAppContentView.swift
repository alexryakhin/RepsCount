import SwiftUI
import StoreKit

struct AboutAppContentView: View {

    @Environment(\.requestReview) var requestReview

    @ObservedObject var viewModel: AboutAppViewModel

    init(viewModel: AboutAppViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            // MARK: - About

            Section {
                Text("Welcome to RepsCount, your companion for tracking and improving your workout performance!\nI created this app because I myself needed something simple yet powerful to track my progress, and it's pretty hard to do it just in Notes App.\nIf you like the app, please leave a review")
                    .multilineTextAlignment(.leading)
                if let appVersion = GlobalConstant.appVersion {
                    HStack(spacing: 8) {
                        Text("App version:")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text("About app")
            }

            // MARK: - Follow Me

            Section {
                Text("Have questions, suggestions, or feedback? I'd love to hear from you. Reach out to get support on Instagram or Twitter!")
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
        .additionalState(viewModel.additionalState)
        .withAlertManager()
        .onAppear {
            AnalyticsService.shared.logEvent(.aboutAppScreenOpened)
        }
    }
}

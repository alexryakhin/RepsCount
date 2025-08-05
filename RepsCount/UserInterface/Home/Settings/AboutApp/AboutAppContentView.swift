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
                Text(Loc.AboutApp.welcomeMessage.localized)
                    .multilineTextAlignment(.leading)
                if let appVersion = GlobalConstant.appVersion {
                    HStack(spacing: 8) {
                        Text(Loc.Settings.appVersion.localized)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text(Loc.Navigation.aboutApp.localized)
            }

            // MARK: - Follow Me

            Section {
                Text(Loc.AboutApp.contactMessage.localized)
                Button {
                    UIApplication.shared.open(GlobalConstant.twitterUrl)
                    AnalyticsService.shared.logEvent(.twitterButtonTapped)
                } label: {
                    Label(Loc.AboutApp.twitter.localized, systemImage: "bird")
                }
                Button {
                    UIApplication.shared.open(GlobalConstant.instagramUrl)
                    AnalyticsService.shared.logEvent(.instagramButtonTapped)
                } label: {
                    Label(Loc.AboutApp.instagram.localized, systemImage: "camera")
                }
            } header: {
                Text(Loc.Settings.contactMe.localized)
            }

            // MARK: - Review section

            Section {
                Button {
                    UIApplication.shared.open(GlobalConstant.buyMeACoffeeUrl)
                    AnalyticsService.shared.logEvent(.buyMeACoffeeTapped)
                } label: {
                    Label(Loc.Settings.buyMeCoffee.localized, systemImage: "cup.and.saucer.fill")
                        .foregroundColor(.orange)
                }
                if viewModel.isShowingRating {
                    Button {
                        requestReview()
                    } label: {
                        Label(Loc.Settings.rateApp.localized, systemImage: "star.fill")
                            .foregroundStyle(Color.yellow)
                    }
                }
            } header: {
                Text(Loc.Settings.support.localized)
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

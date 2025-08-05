import SwiftUI
import StoreKit

struct AboutAppContentView: View {

    @Environment(\.requestReview) var requestReview

    @ObservedObject var viewModel: AboutAppViewModel

    init(viewModel: AboutAppViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                aboutSectionView
                contactSectionView
                supportSectionView
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .navigationTitle(Loc.Navigation.aboutApp.localized)
        .background(Color(.systemGroupedBackground))
        .additionalState(viewModel.additionalState)
        .withAlertManager()
        .onAppear {
            AnalyticsService.shared.logEvent(.aboutAppScreenOpened)
        }
    }
    
    private var aboutSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Loc.Navigation.aboutApp.localized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                Text(Loc.AboutApp.welcomeMessage.localized)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemGroupedBackground))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    )
                
                if let appVersion = GlobalConstant.appVersion {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "info.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Loc.Settings.appVersion.localized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text(appVersion)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemGroupedBackground))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    )
                }
            }
        }
    }
    
    private var contactSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Loc.Settings.contactMe.localized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                Text(Loc.AboutApp.contactMessage.localized)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemGroupedBackground))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    )
                
                Button {
                    UIApplication.shared.open(GlobalConstant.twitterUrl)
                    AnalyticsService.shared.logEvent(.twitterButtonTapped)
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "bird")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Loc.AboutApp.twitter.localized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Follow on Twitter")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
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
                
                Button {
                    UIApplication.shared.open(GlobalConstant.instagramUrl)
                    AnalyticsService.shared.logEvent(.instagramButtonTapped)
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.pink.opacity(0.1))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "camera")
                                .font(.title2)
                                .foregroundColor(.pink)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Loc.AboutApp.instagram.localized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Follow on Instagram")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
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
    
    private var supportSectionView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Loc.Settings.support.localized)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                Button {
                    UIApplication.shared.open(GlobalConstant.buyMeACoffeeUrl)
                    AnalyticsService.shared.logEvent(.buyMeACoffeeTapped)
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.1))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Loc.Settings.buyMeCoffee.localized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Support the development")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
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
                
                if viewModel.isShowingRating {
                    Button {
                        requestReview()
                    } label: {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.yellow.opacity(0.1))
                                    .frame(width: 48, height: 48)
                                
                                Image(systemName: "star.fill")
                                    .font(.title2)
                                    .foregroundColor(.yellow)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(Loc.Settings.rateApp.localized)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Text("Rate on App Store")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.up.right")
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
    }
}

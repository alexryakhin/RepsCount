//
//  AboutAppView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 2/24/24.
//

import SwiftUI
import StoreKit

struct AboutAppView: View {
    @Environment(\.requestReview) var requestReview

    var body: some View {
        List {
            Section {
                Text("Welcome to RepsCount, your companion for tracking and improving your workout performance!\n\nI created this app because I myself needed something simple yet powerful to track my progress, and it's pretty hard to do it just in Notes App.\n\nIf you like the app, please leave a review")
                    .fontWeight(.medium)
                Button("Review the app") {
                    requestReview()
                }
            }
            Section("Version") {
                Text(currentFullAppVersion)
                    .fontWeight(.medium)
            }
            Section("What's new") {
                Text(whatsNew)
            }
            Section("Contact me") {
                Text("Have questions, suggestions, or feedback? I'd love to hear from you. Reach out to get support on Instagram or Twitter!")
                Link("Instagram", destination: URL(string: "https://www.instagram.com/xander1100001")!)
                Link("Twitter", destination: URL(string: "https://www.twitter.com/xander1100001")!)
            }
        }
        .navigationTitle("About App")
    }

    var currentFullAppVersion: String {
        String(GlobalConstant.appVersion ?? "-", GlobalConstant.buildVersion ?? "–", separator: ".")
    }

    var whatsNew: String {
"""
This app has just launched!
There are several features available for you.\n
1. You can optionally add weight to your reps.
2. You can add notes to an exercise.
3. You can see specific dates on the main list with your exercises.
4. Time counts from the first rep till the last one.
5. You cannot edit (add new reps, or remove existing reps) on the next day. But you still can remove the entire exercise if you'd like.
"""
    }
}

#Preview {
    NavigationView {
        AboutAppView()
    }
}

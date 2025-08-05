//
//  OnboardingView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/10/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            VStack {
                Text("Welcome to\nReps Counter")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)
                    .padding(.top, 70)

                Spacer()

                VStack(alignment: .leading, spacing: 25) {
                    ForEach(onboardingCases) { oCase in
                        HStack {
                            Image(systemName: oCase.icon)
                                .frame(sideLength: 40)
                                .foregroundColor(.accentColor)
                                .padding(16)
                            VStack(alignment: .leading, spacing: 5) {
                                Text(oCase.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(oCase.subTitle)
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .padding(16)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Text("Continue")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .cornerRadius(12)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 16)

                Spacer().frame(height: 40)
            }
        }
    }

    struct OnboardingCase: Identifiable {
        let id = UUID().uuidString
        let icon: String
            let title: String
    let subTitle: String
    }

    private var onboardingCases = [
        OnboardingCase(
            icon: "figure.run.square.stack",
            title: "Create templates",
            subTitle: "Have ready-to-go workouts for any day"),
        OnboardingCase(
            icon: "figure.strengthtraining.functional",
            title: "Track exercises",
            subTitle: "Easily track every rep you perform"),
        OnboardingCase(
            icon: "calendar",
            title: "Plan ahead",
            subTitle: "Use the calendar to plan your workouts"),
//        OnboardingCase(
//            icon: "applewatch",
//            title: "Apple Watch App",
//            subTitle: "Leave your phone at home and train with the watch only!")
    ]
}

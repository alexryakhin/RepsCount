//
//  ExercisesListContentView.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI
import CoreUserInterface
import CoreNavigation
import Core
import StoreKit
import struct Services.AnalyticsService

public struct ExercisesListContentView: PageView {

    public typealias ViewModel = ExercisesListViewModel

    @AppStorage(UDKeys.isShowingRating) var isShowingRating: Bool = true
    @AppStorage(UDKeys.isShowingOnboarding) var isShowingOnboarding: Bool = true
    @Environment(\.requestReview) var requestReview
    @ObservedObject public var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var contentView: some View {
        Text("ExercisesListContentView")
            .sheet(isPresented: $isShowingOnboarding) {
                isShowingOnboarding = false
            } content: {
                OnboardingView()
            }
    }

    public func placeholderView(props: PageState.PlaceholderProps) -> some View {
        EmptyListView(
            label: "No exercises yet",
            description: "Begin to add exercises to your list by tapping on plus icon in upper left corner"
        ) {
            Button("Add your first exercise!", action: addItem)
                .buttonStyle(.borderedProminent)
        }
    }

    private func addItem() {
//        if isShowingRating && viewModel.exercises.count > 15 {
//            requestReview()
//            isShowingRating = false
//        }
        viewModel.handle(.showAddExercise)
    }
}

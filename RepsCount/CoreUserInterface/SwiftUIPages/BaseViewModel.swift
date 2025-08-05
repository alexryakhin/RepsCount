//
//  BaseViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation
import Combine
import SwiftUI

enum AdditionalState {
    case loading
    case placeholder(title: String, subtitle: String)
    case none
}

@MainActor
class BaseViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var additionalState: AdditionalState = .none
    @Published var error: Error?
    @Published var isShowingAlert: Bool = false
    @Published var alertModel = AlertModel(title: "")
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    func loadingStarted() {
        additionalState = .loading
    }
    
    func loadingFinished() {
        additionalState = .none
    }
    
    func showPlaceholder(title: String, subtitle: String) {
        additionalState = .placeholder(title: title, subtitle: subtitle)
    }
    
    func showAlert(withModel model: AlertModel) {
        if isShowingAlert {
            isShowingAlert = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.showAlert(withModel: model)
            }
            return
        }
        alertModel = model
        isShowingAlert = true
    }
    
    func showError(_ error: Error) {
        self.error = error
        showAlert(withModel: .init(
            title: Loc.Alerts.error.localized,
            message: error.localizedDescription,
            actionText: Loc.Common.ok.localized
        ))
    }
    
    func resetAdditionalState() {
        additionalState = .none
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        // Override in subclasses if needed
    }
} 

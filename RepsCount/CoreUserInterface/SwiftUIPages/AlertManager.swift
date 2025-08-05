//
//  AlertManager.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation
import SwiftUI

@MainActor
class AlertManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = AlertManager()
    
    // MARK: - Published Properties
    
    @Published var isShowingAlert: Bool = false
    @Published var alertModel = AlertModel(title: "")
    
    // MARK: - Private Init
    
    private init() {}
    
    // MARK: - Public Methods
    
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
    
    func showError(_ error: CoreError) {
        showAlert(withModel: .init(
            title: "Error",
            message: error.description,
            actionText: "OK"
        ))
    }
    
    func showConfirmation(
        title: String,
        message: String,
        actionText: String = "Cancel",
        destructiveActionText: String,
        action: @escaping () -> Void,
        destructiveAction: @escaping () -> Void
    ) {
        showAlert(withModel: .init(
            title: title,
            message: message,
            actionText: actionText,
            destructiveActionText: destructiveActionText,
            action: action,
            destructiveAction: destructiveAction
        ))
    }
    
    func showConfirmation(
        title: String,
        message: String,
        actionText: String = "OK",
        action: @escaping () -> Void
    ) {
        showAlert(withModel: .init(
            title: title,
            message: message,
            actionText: actionText,
            action: action
        ))
    }
} 
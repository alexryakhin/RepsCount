//
//  ViewModifiers.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

// MARK: - Additional State Modifier

struct AdditionalStateModifier: ViewModifier {
    let additionalState: AdditionalState
    
    func body(content: Content) -> some View {
        content
            .overlay {
                switch additionalState {
                case .loading:
                    Color(.systemGroupedBackground).ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.2)
                case .placeholder(let title, let subtitle):
                    Color(.systemGroupedBackground).ignoresSafeArea()
                    ContentUnavailableView(
                        title,
                        systemImage: "tray",
                        description: Text(subtitle)
                    )
                case .none:
                    EmptyView()
                }
            }
    }
}

// MARK: - Alert Modifier

struct AlertModifier: ViewModifier {
    @ObservedObject var alertManager: AlertManager
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $alertManager.isShowingAlert) {
                if let message = alertManager.alertModel.message,
                   let actionText = alertManager.alertModel.actionText,
                   let destructiveActionText = alertManager.alertModel.destructiveActionText
                {
                    return Alert(
                        title: Text(alertManager.alertModel.title),
                        message: Text(message),
                        primaryButton: .destructive(Text(destructiveActionText), action: alertManager.alertModel.destructiveAction),
                        secondaryButton: .cancel(Text(actionText), action: alertManager.alertModel.action)
                    )
                } else if let message = alertManager.alertModel.message,
                          let actionText = alertManager.alertModel.actionText
                {
                    return Alert(
                        title: Text(alertManager.alertModel.title),
                        message: Text(message),
                        dismissButton: .default(Text(actionText), action: alertManager.alertModel.action)
                    )
                } else if let message = alertManager.alertModel.message {
                    return Alert(
                        title: Text(alertManager.alertModel.title),
                        message: Text(message),
                        dismissButton: .default(Text("OK"))
                    )
                } else {
                    return Alert(
                        title: Text(alertManager.alertModel.title),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
    }
}

// MARK: - View Extensions

extension View {
    func additionalState(_ state: AdditionalState) -> some View {
        modifier(AdditionalStateModifier(additionalState: state))
    }
    
    func withAlertManager(_ alertManager: AlertManager = .shared) -> some View {
        modifier(AlertModifier(alertManager: alertManager))
    }
} 

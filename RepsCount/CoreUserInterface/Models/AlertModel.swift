//
//  AlertModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI
import Shared

public struct AlertModel {
    public let title: LocalizedStringKey
    public let message: LocalizedStringKey?
    public let actionText: LocalizedStringKey?
    public let destructiveActionText: LocalizedStringKey?
    public let action: VoidHandler?
    public let destructiveAction: VoidHandler?

    public init(
        title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        actionText: LocalizedStringKey? = nil,
        destructiveActionText: LocalizedStringKey? = nil,
        action: VoidHandler? = nil,
        destructiveAction: VoidHandler? = nil
    ) {
        self.title = title
        self.message = message
        self.action = action
        self.destructiveAction = destructiveAction
        self.destructiveActionText = destructiveActionText
        self.actionText = actionText
    }
}

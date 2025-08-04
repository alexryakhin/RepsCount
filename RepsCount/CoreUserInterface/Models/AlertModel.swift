//
//  AlertModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI

struct AlertModel {
    let title: LocalizedStringKey
    let message: LocalizedStringKey?
    let actionText: LocalizedStringKey?
    let destructiveActionText: LocalizedStringKey?
    let action: VoidHandler?
    let destructiveAction: VoidHandler?

    init(
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

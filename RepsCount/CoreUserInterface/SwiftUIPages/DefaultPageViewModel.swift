//
//  DefaultPageViewModel.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation
import Combine

class DefaultPageViewModel: PageViewModel<DefaultLoaderProps, DefaultPlaceholderProps, DefaultErrorProps> {

    @Published var alertModel = AlertModel(title: .init(.empty))

    override func defaultPageErrorHandler(_ error: CoreError, action: @escaping VoidHandler) {
        let props: DefaultErrorProps? = switch error {
        case .networkError(let error):
                .common(message: error.description, action: action)
        case .storageError(let error):
                .common(message: error.description, action: action)
        case .validationError(let error):
                .common(message: error.description, action: action)
        case .internalError(let error):
                .common(message: error.description, action: action)
        default:
                .common(message: "Unknown error", action: action)
        }
        if let props {
            presentErrorPage(withProps: props)
        }
    }

    override func presentErrorPage(withProps errorProps: DefaultErrorProps) {
        additionalState = .error(errorProps)
    }

    override func loadingStarted() {
        additionalState = .loading()
    }

    override func showAlert(withModel model: AlertModel) {
        if isShowingAlert {
            isShowingAlert = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                self?.showAlert(withModel: model)
            })
            return
        }
        alertModel = model
        isShowingAlert = true
    }
}

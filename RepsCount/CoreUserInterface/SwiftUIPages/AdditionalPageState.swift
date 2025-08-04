//
//  AdditionalPageState.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation

enum AdditionalPageState<
    LoaderProps,
    PlaceholderProps,
    ErrorProps
> {
    typealias LoaderProps = LoaderProps
    typealias PlaceholderProps = PlaceholderProps
    typealias ErrorProps = ErrorProps

    case loading(LoaderProps = DefaultLoaderProps())
    case placeholder(PlaceholderProps = DefaultPlaceholderProps())
    case error(ErrorProps)

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var isEmpty: Bool {
        if case .placeholder = self {
            return true
        }
        return false
    }

    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
}

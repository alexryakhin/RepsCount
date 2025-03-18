//
//  CoreError.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Foundation

public enum CoreError: Error {
    case networkError(NetworkError)
    case storageError(StorageError)
    case validationError(ValidationError)
    case internalError(InternalError)
    case eventStoreError(EventStoreError)
    case unknownError

    // Nested enum for Network Errors
    public enum NetworkError: Error {
        case timeout
        case serverUnreachable
        case invalidResponse(statusCode: Int? = nil)
        case noInternetConnection
        case missingAPIKey
        case decodingError
        case invalidURL
        case noData

        public var description: String {
            switch self {
            case .timeout: "Timeout"
            case .serverUnreachable: "Server unreachable"
            case .invalidResponse(let code): "Invalid response: \(code ?? 0)"
            case .noInternetConnection: "No internet connection"
            case .missingAPIKey: "Missing API key"
            case .decodingError: "Decoding error"
            case .invalidURL: "Invalid URL"
            case .noData: "No data"
            }
        }
    }

    // StorageError and ValidationError can follow a similar pattern if needed
    public enum StorageError: Error {
        case saveFailed
        case readFailed
        case dataCorrupted

        public var description: String {
            switch self {
            case .saveFailed: "Save failed"
            case .readFailed: "Read failed"
            case .dataCorrupted: "Data corrupted"
            }
        }
    }

    public enum ValidationError: Error {
        case invalidInput(field: String)
        case missingField(field: String)

        public var description: String {
            switch self {
            case .invalidInput(field: let field): "Invalid input for field: \(field)"
            case .missingField(field: let field): "Missing field: \(field)"
            }
        }
    }

    public enum InternalError: Error {
        case removingExerciseFailed
        case removingTemplateFailed
        case removingEventFailed
        case inputCannotBeEmpty

        public var description: String {
            switch self {
            case .removingExerciseFailed:
                return "Removing exercise failed"
            case .removingTemplateFailed:
                return "Removing template failed"
            case .removingEventFailed:
                return "Removing event failed"
            case .inputCannotBeEmpty:
                return "Input cannot be empty"
            }
        }
    }

    public enum EventStoreError: Error {
        case denied
        case restricted
        case unknown
        case upgrade

        public var description: String {
            switch self {
            case .denied:
                return NSLocalizedString("The app doesn't have permission to Calendar in Settings.", comment: "Access denied")
             case .restricted:
                return NSLocalizedString("This device doesn't allow access to Calendar.", comment: "Access restricted")
            case .unknown:
                return NSLocalizedString("An unknown error occured.", comment: "Unknown error")
            case .upgrade:
                let access = "The app has write-only access to Calendar in Settings."
                let update = "Please grant it full access so the app can fetch and delete your events."
                return NSLocalizedString("\(access) \(update)", comment: "Upgrade to full access")
            }
        }
    }

    public var description: String {
        switch self {
        case .networkError(let error): error.description
        case .storageError(let error): error.description
        case .validationError(let error): error.description
        case .internalError(let error): error.description
        case .eventStoreError(let error): error.description
        case .unknownError: "Unknown error"
        }
    }
}

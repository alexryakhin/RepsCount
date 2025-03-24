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
        case invalidResponse
        case noInternetConnection
        case missingAPIKey
        case decodingError
        case invalidURL
        case noData

        public var description: String {
            switch self {
            case .timeout: NSLocalizedString("Timeout", comment: .empty)
            case .serverUnreachable: NSLocalizedString("Server unreachable", comment: .empty)
            case .invalidResponse: NSLocalizedString("Invalid response", comment: .empty)
            case .noInternetConnection: NSLocalizedString("No internet connection", comment: .empty)
            case .missingAPIKey: NSLocalizedString("Missing API key", comment: .empty)
            case .decodingError: NSLocalizedString("Decoding error", comment: .empty)
            case .invalidURL: NSLocalizedString("Invalid URL", comment: .empty)
            case .noData: NSLocalizedString("No data", comment: .empty)
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
            case .saveFailed: NSLocalizedString("Save failed", comment: .empty)
            case .readFailed: NSLocalizedString("Read failed", comment: .empty)
            case .dataCorrupted: NSLocalizedString("Data corrupted", comment: .empty)
            }
        }
    }

    public enum ValidationError: Error {
        case invalidInput
        case missingField

        public var description: String {
            switch self {
            case .invalidInput: NSLocalizedString("Invalid input", comment: .empty)
            case .missingField: NSLocalizedString("Missing field", comment: .empty)
            }
        }
    }

    public enum InternalError: Error {
        case removingExerciseFailed
        case removingTemplateFailed
        case removingEventFailed
        case removingSetFailed
        case templateNotFound
        case eventAlreadyExists
        case inputCannotBeEmpty
        case cancelingRecurrenceFailed
        case addingWorkoutFailed
        case removingWorkoutFailed
        case workoutCompleted
        case unableToCompleteEmptyWorkout

        public var description: String {
            switch self {
            case .removingExerciseFailed:
                return NSLocalizedString("Removing exercise failed", comment: .empty)
            case .removingTemplateFailed:
                return NSLocalizedString("Removing template failed", comment: .empty)
            case .removingEventFailed:
                return NSLocalizedString("Removing event failed", comment: .empty)
            case .removingSetFailed:
                return NSLocalizedString("Removing set failed", comment: .empty)
            case .templateNotFound:
                return NSLocalizedString("Template not found", comment: .empty)
            case .eventAlreadyExists:
                return NSLocalizedString("Event already exists", comment: .empty)
            case .inputCannotBeEmpty:
                return NSLocalizedString("Input cannot be empty", comment: .empty)
            case .cancelingRecurrenceFailed:
                return NSLocalizedString("Canceling recurrence failed", comment: .empty)
            case .addingWorkoutFailed:
                return NSLocalizedString("Adding workout failed", comment: .empty)
            case .removingWorkoutFailed:
                return NSLocalizedString("Removing workout failed", comment: .empty)
            case .workoutCompleted:
                return NSLocalizedString("Workout completed", comment: .empty)
            case .unableToCompleteEmptyWorkout:
                return NSLocalizedString("Unable to complete empty workout", comment: .empty)
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
                return NSLocalizedString("The app doesn't have permission to Calendar in Settings.", comment: .empty)
             case .restricted:
                return NSLocalizedString("This device doesn't allow access to Calendar.", comment: .empty)
            case .unknown:
                return NSLocalizedString("An unknown error occurred.", comment: .empty)
            case .upgrade:
                return NSLocalizedString("The app has write-only access to Calendar in Settings. Please grant it full access so the app can fetch and delete your events.", comment: .empty)
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
        case .unknownError: NSLocalizedString("An unknown error occurred.", comment: .empty)
        }
    }
}

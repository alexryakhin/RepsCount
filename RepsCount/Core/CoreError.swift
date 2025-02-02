//
//  CoreError.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/28/24.
//

import Foundation

enum CoreError: Error {
    case storageError(StorageError)
    case validationError(ValidationError)
    case unknownError

    // StorageError and ValidationError can follow a similar pattern if needed
    enum StorageError: Error {
        case saveFailed
        case readFailed
        case dataCorrupted

        var description: String {
            switch self {
            case .saveFailed: "Save failed"
            case .readFailed: "Read failed"
            case .dataCorrupted: "Data corrupted"
            }
        }

    }

    enum ValidationError: Error {
        case invalidInput(field: String)
        case missingField(field: String)

        var description: String {
            switch self {
            case .invalidInput(field: let field): "Invalid input for field: \(field)"
            case .missingField(field: let field): "Missing field: \(field)"
            }
        }

    }

    var description: String {
        switch self {
        case .storageError(let error): error.description
        case .validationError(let error): error.description
        case .unknownError: "Unknown error"
        }
    }
}

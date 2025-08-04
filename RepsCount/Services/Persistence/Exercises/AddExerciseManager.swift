//
//  AddExerciseManager.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/12/25.
//

import Foundation
import CoreData

protocol AddExerciseManagerInterface {
    func addExercise(from model: ExerciseModel, savesLocation: Bool) throws(CoreError)
}

final class AddExerciseManager: AddExerciseManagerInterface {

    private let coreDataService: CoreDataServiceInterface
    private let locationManager: LocationManagerInterface

    init(
        coreDataService: CoreDataServiceInterface,
        locationManager: LocationManagerInterface
    ) {
        self.coreDataService = coreDataService
        self.locationManager = locationManager
    }

    func addExercise(from model: ExerciseModel, savesLocation: Bool) throws(CoreError) {
        Task { @MainActor in
            let newItem = CDExercise(context: coreDataService.context)
            newItem.timestamp = .now
            newItem.name = model.rawValue
            newItem.id = UUID().uuidString
            if savesLocation, let location = try await locationManager.getCurrentLocation() {
                newItem.latitude = location.latitude
                newItem.longitude = location.longitude
                newItem.address = location.address
                debugPrint(location)
            }
            try coreDataService.saveContext()
        }
    }
}

//
//  AddWorkoutManager.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/12/25.
//

import Foundation
import CoreData

protocol AddWorkoutManagerInterface {
    func addOpenWorkout() throws(CoreError) -> WorkoutInstance?
    func addWorkout(from template: WorkoutTemplate, savesLocation: Bool) async throws(CoreError) -> WorkoutInstance?
    func addWorkout(from event: WorkoutEvent, savesLocation: Bool) async throws(CoreError) -> WorkoutInstance?
}

final class AddWorkoutManager: AddWorkoutManagerInterface {

    private let coreDataService: CoreDataServiceInterface
    private let locationManager: LocationManagerInterface

    init(
        coreDataService: CoreDataServiceInterface,
        locationManager: LocationManagerInterface
    ) {
        self.coreDataService = coreDataService
        self.locationManager = locationManager
    }

    func addWorkout(from event: WorkoutEvent, savesLocation: Bool) async throws(CoreError) -> WorkoutInstance? {
        if let workout = try getWorkoutInstance(with: event.id) {
            return workout.coreModel
        }

        let newItem = CDWorkoutInstance(context: coreDataService.context)
        newItem.date = .now
        newItem.id = event.id
        newItem.name = event.template.name
        newItem.workoutEvent = try getEvent(with: event.id)
        newItem.workoutTemplate = newItem.workoutEvent?.workoutTemplate
        for exercise in event.template.templateExercises {
            let newCDExercise = CDExercise(context: coreDataService.context)
            newCDExercise.timestamp = .now
            newCDExercise.name = exercise.exerciseModel.rawValue
            newCDExercise.id = UUID().uuidString
            newCDExercise.defaultAmount = exercise.defaultAmount
            newCDExercise.defaultSets = exercise.defaultSets
            if savesLocation, let location = try await locationManager.getCurrentLocation() {
                newCDExercise.latitude = location.latitude
                newCDExercise.longitude = location.longitude
                newCDExercise.address = location.address
            }
            newCDExercise.workoutInstance = newItem
            newItem.addToExercises(newCDExercise)
        }
        try coreDataService.saveContext()
        return newItem.coreModel
    }

    func addWorkout(from template: WorkoutTemplate, savesLocation: Bool) async throws(CoreError) -> WorkoutInstance? {
        let newItem = CDWorkoutInstance(context: coreDataService.context)
        newItem.date = .now
        newItem.id = UUID().uuidString
        newItem.name = template.name
        newItem.workoutTemplate = try getTemplate(with: template.id)
        for exercise in template.templateExercises {
            let newCDExercise = CDExercise(context: coreDataService.context)
            newCDExercise.timestamp = .now
            newCDExercise.name = exercise.exerciseModel.rawValue
            newCDExercise.id = UUID().uuidString
            newCDExercise.defaultAmount = exercise.defaultAmount
            newCDExercise.defaultSets = exercise.defaultSets
            if savesLocation, let location = try await locationManager.getCurrentLocation() {
                newCDExercise.latitude = location.latitude
                newCDExercise.longitude = location.longitude
                newCDExercise.address = location.address
            }
            newCDExercise.workoutInstance = newItem
            newItem.addToExercises(newCDExercise)
        }
        try coreDataService.saveContext()
        return newItem.coreModel
    }

    func addOpenWorkout() throws(CoreError) -> WorkoutInstance? {
        let newItem = CDWorkoutInstance(context: coreDataService.context)
        newItem.date = .now
        newItem.id = UUID().uuidString
        try coreDataService.saveContext()
        return newItem.coreModel
    }

    private func getEvent(with id: String) throws(CoreError) -> CDWorkoutEvent? {
        let request = CDWorkoutEvent.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            return try coreDataService.context.fetch(request).first
        } catch {
            throw(CoreError.storageError(.readFailed))
        }
    }

    private func getTemplate(with id: String) throws(CoreError) -> CDWorkoutTemplate? {
        let request = CDWorkoutTemplate.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            return try coreDataService.context.fetch(request).first
        } catch {
            throw(CoreError.storageError(.readFailed))
        }
    }

    private func getWorkoutInstance(with id: String) throws(CoreError) -> CDWorkoutInstance? {
        let request = CDWorkoutInstance.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            return try coreDataService.context.fetch(request).first
        } catch {
            throw(CoreError.storageError(.readFailed))
        }
    }
}

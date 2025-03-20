//
//  AddWorkoutManager.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/12/25.
//

import Foundation
import CoreData
import Core

public protocol AddWorkoutManagerInterface {
    func addOpenWorkout() throws(CoreError) -> WorkoutInstance?
    func addWorkout(from template: WorkoutTemplate, savesLocation: Bool) async throws(CoreError) -> WorkoutInstance?
    func addWorkout(from event: WorkoutEvent, savesLocation: Bool) async throws(CoreError) -> WorkoutInstance?
}

public final class AddWorkoutManager: AddWorkoutManagerInterface {

    private let coreDataService: CoreDataServiceInterface
    private let locationManager: LocationManagerInterface

    public init(
        coreDataService: CoreDataServiceInterface,
        locationManager: LocationManagerInterface
    ) {
        self.coreDataService = coreDataService
        self.locationManager = locationManager
    }

    public func addWorkout(from event: WorkoutEvent, savesLocation: Bool) async throws(CoreError) -> WorkoutInstance? {
        if let workout = try getWorkoutInstance(with: event.id) {
            return workout.coreModel
        }

        let newItem = CDWorkoutInstance(context: coreDataService.context)
        newItem.date = .now
        newItem.id = event.id
        newItem.workoutEvent = try getEvent(with: event.id)
        newItem.workoutTemplate = newItem.workoutEvent?.workoutTemplate
        for exercise in event.template.templateExercises {
            let newCDExercise = CDExercise(context: coreDataService.context)
            newCDExercise.timestamp = .now
            newCDExercise.name = exercise.exerciseModel.rawValue
            newCDExercise.id = UUID().uuidString
            newCDExercise.defaultReps = exercise.defaultReps.int64
            newCDExercise.defaultSets = exercise.defaultSets.int64
            newCDExercise.sortingOrder = exercise.sortingOrder.int64
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

    public func addWorkout(from template: WorkoutTemplate, savesLocation: Bool) async throws(CoreError) -> WorkoutInstance? {
        let newItem = CDWorkoutInstance(context: coreDataService.context)
        newItem.date = .now
        newItem.id = UUID().uuidString
        newItem.workoutTemplate = try getTemplate(with: template.id)
        for exercise in template.templateExercises {
            let newCDExercise = CDExercise(context: coreDataService.context)
            newCDExercise.timestamp = .now
            newCDExercise.name = exercise.exerciseModel.rawValue
            newCDExercise.id = UUID().uuidString
            newCDExercise.defaultReps = exercise.defaultReps.int64
            newCDExercise.defaultSets = exercise.defaultSets.int64
            newCDExercise.sortingOrder = exercise.sortingOrder.int64
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

    public func addOpenWorkout() throws(CoreError) -> WorkoutInstance? {
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

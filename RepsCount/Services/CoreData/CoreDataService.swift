//
//  CoreDataService.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on January 6, 2025.
//

import CoreData
import SwiftUI

protocol CoreDataServiceInterface {
    var context: NSManagedObjectContext { get }
    func saveContext() throws(CoreError)
}

final class CoreDataService: CoreDataServiceInterface {

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentCloudKitContainer(name: "RepsCount")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() throws(CoreError) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw .storageError(.saveFailed)
            }
        }
    }
}

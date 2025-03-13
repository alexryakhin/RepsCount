//
//  NotificationCenter+Extension.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import Combine
import CoreData

extension NotificationCenter {
    var eventChangedPublisher: NotificationCenter.Publisher {
        publisher(for: NSPersistentCloudKitContainer.eventChangedNotification)
    }
    var coreDataDidSaveObjectIDsPublisher: NotificationCenter.Publisher {
        publisher(for: .NSManagedObjectContextDidSaveObjectIDs)
    }
}

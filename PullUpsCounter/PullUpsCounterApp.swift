//
//  PullUpsCounterApp.swift
//  PullUpsCounter
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI

@main
struct PullUpsCounterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .fontDesign(.rounded)
        }
    }
}

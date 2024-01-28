//
//  RepsCountApp.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/13/24.
//

import SwiftUI

@main
struct RepsCountApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabViewScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .fontDesign(.rounded)
        }
    }
}

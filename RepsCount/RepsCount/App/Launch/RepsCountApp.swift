//
//  RepsCountApp.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/8/25.
//

import SwiftUI
import Firebase

@main
struct RepsCountApp: App {
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
    }
    
    // MARK: - Initialization
    
    init() {
        FirebaseApp.configure()
    }
} 

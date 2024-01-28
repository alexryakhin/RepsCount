//
//  TabViewScreen.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/28/24.
//

import SwiftUI

struct TabViewScreen: View {
    var body: some View {
        TabView {
            ExercisesView()
                .tabItem {
                    Label(
                        title: { Text("Exercises") },
                        icon: { Image(systemName: "dumbbell") }
                    )
                }
            SettingsView()
                .tabItem {
                    Label(
                        title: { Text("Settings") },
                        icon: { Image(systemName: "gear") }
                    )
                }
        }
    }
}

#Preview {
    TabViewScreen()
}

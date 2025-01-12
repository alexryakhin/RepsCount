//
//  TabViewScreen.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 1/28/24.
//

import SwiftUI

struct TabViewScreen: View {

    let resolver = DIContainer.shared.resolver

    var body: some View {
        TabView {
            resolver.resolve(ExercisesView.self)!
                .tabItem {
                    Label(
                        title: { Text("Exercises") },
                        icon: { Image(systemName: "dumbbell") }
                    )
                }
            resolver.resolve(CalendarScreen.self)!
                .tabItem {
                    Label(
                        title: { Text("Calendar") },
                        icon: { Image(systemName: "calendar") }
                    )
                }
            resolver.resolve(SettingsView.self)!
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

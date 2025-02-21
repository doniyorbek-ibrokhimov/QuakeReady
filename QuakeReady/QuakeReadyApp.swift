//
//  QuakeReadyApp.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 16/02/25.
//

import SwiftUI
import SwiftData

@main
struct QuakeReadyApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(
                for: BadgeAchievement.self, DrillAchievement.self
            )
        } catch {
            //FIXME: handle it properly
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(modelContext: container.mainContext)
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
    }
}

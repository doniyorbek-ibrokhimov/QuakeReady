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
    @AppStorage(UserDefaultsKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    
    init() {
        do {
            container = try ModelContainer(
                for: BadgeAchievement.self,
                DrillAchievement.self,
                QuizAchievement.self
            )
        } catch {
            //FIXME: handle it properly
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                HomeView(modelContext: container.mainContext)
                    .preferredColorScheme(.dark)
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .preferredColorScheme(.dark)
            }
        }
        .modelContainer(container)
    }
}

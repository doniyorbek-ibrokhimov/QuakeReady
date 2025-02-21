//
//  BadgeProgress.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI
import SwiftData

/// Tracks and manages the user's progress in earning badges
/// 
/// This class handles:
/// - Loading earned badges from storage
/// - Awarding new badges
/// - Calculating progress statistics
class BadgeProgress: ObservableObject {
    /// Dictionary mapping badge types to their earned dates
    @Published private var earnedBadges: [BadgeType: Date] = [:]
    
    /// SwiftData context for persisting badge achievements
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadPersistedBadges()
    }
    
    /// Number of badges the user has earned
    var earnedBadgesCount: Int {
        earnedBadges.count
    }
    
    /// Total number of available badges
    var totalBadgesCount: Int {
        BadgeType.allCases.count
    }
    
    /// Loads previously earned badges from SwiftData storage
    private func loadPersistedBadges() {
        do {
            let descriptor = FetchDescriptor<BadgeAchievement>()
            let achievements = try modelContext.fetch(descriptor)
            
            for achievement in achievements {
                if let badgeType = BadgeType(rawValue: achievement.type) {
                    earnedBadges[badgeType] = achievement.earnedDate
                }
            }
        } catch {
            print("Failed to fetch badges: \(error)")
        }
    }
    
    /// Checks if a specific badge has been earned
    /// - Parameter type: The badge type to check
    /// - Returns: True if the badge has been earned
    func isEarned(_ type: BadgeType) -> Bool {
        earnedBadges[type] != nil
    }
    
    /// Awards a new badge to the user and persists it
    /// - Parameter type: The badge type to award
    func earnBadge(_ type: BadgeType) {
        let date = Date()
        earnedBadges[type] = date
        
        // Persist to SwiftData
        let achievement = BadgeAchievement(type: type.rawValue, earnedDate: date)
        modelContext.insert(achievement)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save badge: \(error)")
        }
    }
    
    /// Gets the current status of a badge
    /// - Parameter type: The badge type to check
    /// - Returns: The badge's current status (earned or locked)
    func getBadgeStatus(_ type: BadgeType) -> BadgeStatus {
        if let date = earnedBadges[type] {
            return .earned(date: date)
        }
        return .locked(criteria: type.criteria)
    }
} 
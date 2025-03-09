//
//  BadgeGalleryViewModel.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI
import SwiftData

extension BadgeGalleryView {
    /// Manages the state and logic for the badge gallery
    ///
    /// This ViewModel handles:
    /// - Filtering badges (All, Earned, or Locked)
    /// - Tracking selected badges for details view
    /// - Computing badge statistics
    class ViewModel: ObservableObject {
        /// Tracks the user's progress in earning badges
        @Published var badgeProgress: BadgeProgress
        
        /// Current filter selection for badge display
        @Published var selectedFilter: BadgeFilter = .all
        
        /// Currently selected badge for detail view
        @Published var selectedBadge: Badge?
        
        init(modelContext: ModelContext) {
            self.badgeProgress = BadgeProgress(modelContext: modelContext)
        }
        
        /// All available badges with their current status
        var badges: [Badge] {
            BadgeType.allCases.map { type in
                Badge(type: type, status: badgeProgress.getBadgeStatus(type))
            }
        }
        
        /// Badges filtered according to the selected filter
        var filteredBadges: [Badge] {
            switch selectedFilter {
            case .all: return badges
            case .earned: return badges.filter { $0.status.isEarned }
            case .locked: return badges.filter { !$0.status.isEarned }
            }
        }
        
        /// Number of badges the user has earned
        var earnedBadgesCount: Int {
            badgeProgress.earnedBadgesCount
        }
        
        /// Total number of available badges
        var totalBadgesCount: Int {
            badgeProgress.totalBadgesCount
        }
        
        /// Updates the selected badge when user taps on a badge
        func handleBadgeTap(_ badge: Badge) {
            selectedBadge = badge
        }
    }
} 

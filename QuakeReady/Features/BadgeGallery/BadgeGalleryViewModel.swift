import SwiftUI
import SwiftData

extension BadgeGalleryView {
    class ViewModel: ObservableObject {
        @Published var badgeProgress: BadgeProgress
        @Published var selectedFilter: BadgeFilter = .all
        @Published var selectedBadge: Badge?
        
        init(modelContext: ModelContext) {
            self.badgeProgress = BadgeProgress(modelContext: modelContext)
        }
        
        var badges: [Badge] {
            BadgeType.allCases.map { type in
                Badge(type: type, status: badgeProgress.getBadgeStatus(type))
            }
        }
        
        var filteredBadges: [Badge] {
            switch selectedFilter {
            case .all: return badges
            case .earned: return badges.filter { $0.status.isEarned }
            case .locked: return badges.filter { !$0.status.isEarned }
            }
        }
        
        var earnedBadgesCount: Int {
            badgeProgress.earnedBadgesCount
        }
        
        var totalBadgesCount: Int {
            badgeProgress.totalBadgesCount
        }
        
        func handleBadgeTap(_ badge: Badge) {
            selectedBadge = badge
        }
    }
} 

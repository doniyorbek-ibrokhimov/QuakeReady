import SwiftUI
import SwiftData

extension BadgeGalleryView {
    class ViewModel: ObservableObject {
        @Published var badgeProgress: BadgeProgress
        @Published var showingToast = false
        @Published var toastMessage = ""
        @Published var selectedFilter: BadgeFilter = .all
        @Published var selectedBadge: Badge?
        @Published var showingBadgeDetails = false
        
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
            badges.filter { $0.status.isEarned }.count
        }
        
        func handleBadgeTap(_ badge: Badge) {
            selectedBadge = badge
            
            switch badge.status {
            case .earned(let date):
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                toastMessage = "Earned on \(formatter.string(from: date))"
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                showingBadgeDetails = true
                
            case .locked(let criteria):
                toastMessage = "Locked: \(criteria)"
                showingToast = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showingToast = false
                }
            }
        }
    }
} 

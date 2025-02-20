import SwiftUI

extension BadgeGalleryView {
    class ViewModel: ObservableObject {
        @Published var showingToast = false
        @Published var toastMessage = ""
        @Published var selectedFilter: BadgeFilter = .all
        @Published var selectedBadge: Badge?
        @Published var showingBadgeDetails = false
        
        @Published var badges = [
            Badge(
                title: "Quick Learner",
                icon: "bolt.fill",
                status: .locked(criteria: "Score 100% on 5 Quizzes"),
                description: "Awarded for completing your first quiz"
            ),
            Badge(
                title: "Drill Master",
                icon: "figure.run",
                status: .locked(criteria: "Score 100% on 5 Quizzes"),
                description: "Completed 3 earthquake drills"
            ),
            Badge(
                title: "Safety Scholar",
                icon: "book.closed.fill",
                status: .locked(criteria: "Score 100% on 5 Quizzes"),
                description: "Become a safety expert"
            ),
            Badge(
                title: "Global Guardian",
                icon: "globe",
                status: .locked(criteria: "View 10 Countries"),
                description: "Explore earthquake risks worldwide"
            )
        ]
        
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

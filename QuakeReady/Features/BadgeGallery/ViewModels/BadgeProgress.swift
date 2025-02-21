import SwiftUI
import SwiftData

class BadgeProgress: ObservableObject {
    @Published private var earnedBadges: [BadgeType: Date] = [:]
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadPersistedBadges()
    }
    
    var earnedBadgesCount: Int {
        earnedBadges.count
    }
    
    var totalBadgesCount: Int {
        BadgeType.allCases.count
    }
    
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
    
    func isEarned(_ type: BadgeType) -> Bool {
        earnedBadges[type] != nil
    }
    
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
    
    func getBadgeStatus(_ type: BadgeType) -> BadgeStatus {
        if let date = earnedBadges[type] {
            return .earned(date: date)
        }
        return .locked(criteria: type.criteria)
    }
} 
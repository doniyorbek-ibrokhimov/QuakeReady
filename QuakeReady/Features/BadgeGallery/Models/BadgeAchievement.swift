import SwiftData
import Foundation

@Model
class BadgeAchievement {
    let type: String // We'll store BadgeType's rawValue
    let earnedDate: Date
    
    init(type: String, earnedDate: Date) {
        self.type = type
        self.earnedDate = earnedDate
    }
} 
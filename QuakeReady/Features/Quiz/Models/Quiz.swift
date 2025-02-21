import SwiftUI

struct Quiz: Identifiable, Hashable {
    let id: String
    let title: String
    let icon: String
    let category: String
    let questions: [Question]
    
    // Computed properties based on achievements
    var completion: Double {
        guard let achievement = latestAchievement else { return 0.0 }
        return Double(achievement.score) / Double(achievement.totalQuestions)
    }
    var lastAttemptDate: Date? { latestAchievement?.completedDate }
    var bestScore: Int? { latestAchievement?.score }
    
    // Internal property to store achievement data
    var latestAchievement: QuizAchievement?
} 

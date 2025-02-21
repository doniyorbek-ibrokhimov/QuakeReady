import SwiftUI

/// A model representing a quiz module containing multiple questions.
/// Tracks user progress and achievements for the quiz.
struct Quiz: Identifiable, Hashable {
    /// Unique identifier for the quiz.
    let id: UUID
    
    /// The display title of the quiz.
    let title: String
    
    /// SF Symbol name for the quiz's icon.
    let icon: String
    
    /// The category or topic of the quiz.
    let category: String
    
    /// Array of questions included in the quiz.
    let questions: [Question]
    
    /// The user's latest achievement record for this quiz, if any.
    var latestAchievement: QuizAchievement?
    
    // MARK: - Computed Properties
    
    /// The completion percentage for the quiz (0.0-1.0).
    var completion: Double {
        guard let achievement = latestAchievement else { return 0.0 }
        return Double(achievement.score) / Double(achievement.totalQuestions)
    }
    
    /// The date when the quiz was last attempted, if any.
    var lastAttemptDate: Date? { latestAchievement?.completedDate }
    
    /// The highest score achieved on this quiz, if any.
    var bestScore: Int? { latestAchievement?.score }
} 

import SwiftData
import Foundation

@Model
class QuizAchievement {
    /// Unique identifier for the quiz.
    let quizId: UUID
    
    /// Date when the quiz was completed.
    let completedDate: Date
    
    /// The score achieved by the user.
    let score: Int
    
    /// The total number of questions in the quiz.
    let totalQuestions: Int
    
    init(quizId: UUID, completedDate: Date, score: Int, totalQuestions: Int) {
        self.quizId = quizId
        self.completedDate = completedDate
        self.score = score
        self.totalQuestions = totalQuestions
    }
} 
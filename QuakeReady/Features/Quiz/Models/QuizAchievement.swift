import SwiftData
import Foundation

@Model
class QuizAchievement {
    let quizId: UUID
    let completedDate: Date
    let score: Int
    let totalQuestions: Int
    
    init(quizId: UUID, completedDate: Date, score: Int, totalQuestions: Int) {
        self.quizId = quizId
        self.completedDate = completedDate
        self.score = score
        self.totalQuestions = totalQuestions
    }
} 
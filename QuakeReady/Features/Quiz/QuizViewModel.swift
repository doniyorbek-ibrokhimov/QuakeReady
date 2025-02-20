import SwiftUI

extension QuizView {
    @MainActor
    class ViewModel: ObservableObject {
        let quiz: Quiz
        
        @Published var currentQuestionIndex = 0
        @Published var selectedAnswerIndex: Int?
        @Published var showFeedback = false
        @Published var quizCompleted = false
        @Published var correctAnswers = 0
        @Published var previousAnswers: [Int?]
        
        private let badgeProgress: BadgeProgress
        
        init(quiz: Quiz, badgeProgress: BadgeProgress) {
            self.quiz = quiz
            self.badgeProgress = badgeProgress
            self.previousAnswers = Array(repeating: nil, count: quiz.questions.count)
        }
        
        var isLastQuestion: Bool {
            currentQuestionIndex == quiz.questions.count - 1
        }
        
        func selectAnswer(_ index: Int) {
            guard !showFeedback else { return }
            selectedAnswerIndex = index
            showFeedback = true
            previousAnswers[currentQuestionIndex] = index
            
            if index == quiz.questions[currentQuestionIndex].correctIndex {
                correctAnswers += 1
            }
        }
        
        func nextQuestion() {
            if currentQuestionIndex < quiz.questions.count - 1 {
                currentQuestionIndex += 1
                selectedAnswerIndex = previousAnswers[currentQuestionIndex]
                showFeedback = selectedAnswerIndex != nil
            } else {
                completeQuiz()
            }
        }
        
        func prevQuestion() {
            if currentQuestionIndex > 0 {
                currentQuestionIndex -= 1
                selectedAnswerIndex = previousAnswers[currentQuestionIndex]
                showFeedback = selectedAnswerIndex != nil
            }
        }
        
        //FIXME: trigger ui update in badge gallery view
        private func completeQuiz() {
            let isPerfectScore = correctAnswers == quiz.questions.count
            
            // Update quiz completion status
            var updatedQuiz = quiz
            updatedQuiz.completion = Double(correctAnswers) / Double(quiz.questions.count)
            updatedQuiz.lastAttemptDate = Date()
            updatedQuiz.bestScore = max(correctAnswers, quiz.bestScore ?? 0)
            
            // Check and award badges
            if isPerfectScore {
                badgeProgress.earnBadge(.quickLearner)
                
                // Check if all quizzes are completed with perfect scores
                let allQuizzesPerfect = true //FIXME: Implement this check
                if allQuizzesPerfect {
                    badgeProgress.earnBadge(.safetyScholar)
                }
            }
            
            quizCompleted = true
        }
    }
} 

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
        private let quizLibraryViewModel: QuizLibraryView.ViewModel
        
        init(quiz: Quiz, badgeProgress: BadgeProgress, quizLibraryViewModel: QuizLibraryView.ViewModel) {
            self.quiz = quiz
            self.badgeProgress = badgeProgress
            self.quizLibraryViewModel = quizLibraryViewModel
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
            
            // Update quiz completion status through QuizLibraryViewModel
            quizLibraryViewModel.completeQuiz(
                id: quiz.id,
                score: correctAnswers,
                totalQuestions: quiz.questions.count
            )
            
            // Check and award badges
            if isPerfectScore {
                badgeProgress.earnBadge(.quickLearner)
                
                // Check if all quizzes are completed with perfect scores
                let allQuizzesPerfect = quizLibraryViewModel.quizzes.allSatisfy { quiz in
                    quiz.completion == 1.0
                }
                if allQuizzesPerfect {
                    badgeProgress.earnBadge(.safetyScholar)
                }
            }
            
            quizCompleted = true
        }
    }
} 

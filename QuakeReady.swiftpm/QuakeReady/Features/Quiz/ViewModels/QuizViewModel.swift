import SwiftUI

extension QuizView {
    /// View model managing the state and logic of an active quiz session.
    /// Handles question navigation, answer selection, and badge awards.
    @MainActor
    class ViewModel: ObservableObject {
        /// The quiz being taken.
        let quiz: Quiz
        
        /// Index of the current question being displayed (0-based).
        @Published var currentQuestionIndex = 0
        
        /// Index of the selected answer for the current question, if any.
        @Published var selectedAnswerIndex: Int?
        
        /// Controls the visibility of answer feedback.
        @Published var showFeedback = false
        
        /// Indicates whether the quiz has been completed.
        @Published var quizCompleted = false
        
        /// Number of correctly answered questions.
        @Published var correctAnswers = 0
        
        /// Array tracking selected answers for each question.
        @Published var previousAnswers: [Int?]
        
        /// Array of badge types earned during this quiz session.
        @Published var earnedBadges: [BadgeType] = []
        
        /// Service for tracking and awarding badge progress.
        private let badgeProgress: BadgeProgress
        
        /// Parent view model for updating quiz completion status.
        private let quizLibraryViewModel: QuizLibraryView.ViewModel
        
        /// Initializes a new quiz view model.
        /// - Parameters:
        ///   - quiz: The quiz to be taken
        ///   - badgeProgress: Service for tracking badge achievements
        ///   - quizLibraryViewModel: Parent view model for updating completion status
        init(quiz: Quiz, badgeProgress: BadgeProgress, quizLibraryViewModel: QuizLibraryView.ViewModel) {
            self.quiz = quiz
            self.badgeProgress = badgeProgress
            self.quizLibraryViewModel = quizLibraryViewModel
            self.previousAnswers = Array(repeating: nil, count: quiz.questions.count)
        }
        
        /// Indicates whether the current question is the last one.
        var isLastQuestion: Bool {
            currentQuestionIndex == quiz.questions.count - 1
        }
        
        /// Records the user's answer selection for the current question.
        /// - Parameter index: The index of the selected answer
        func selectAnswer(_ index: Int) {
            guard !showFeedback else { return }
            selectedAnswerIndex = index
            showFeedback = true
            previousAnswers[currentQuestionIndex] = index
            
            if index == quiz.questions[currentQuestionIndex].correctIndex {
                correctAnswers += 1
            }
        }
        
        /// Advances to the next question or completes the quiz if on the last question.
        func nextQuestion() {
            if currentQuestionIndex < quiz.questions.count - 1 {
                currentQuestionIndex += 1
                selectedAnswerIndex = previousAnswers[currentQuestionIndex]
                showFeedback = selectedAnswerIndex != nil
            } else {
                completeQuiz()
            }
        }
        
        /// Returns to the previous question if possible.
        func prevQuestion() {
            if currentQuestionIndex > 0 {
                currentQuestionIndex -= 1
                selectedAnswerIndex = previousAnswers[currentQuestionIndex]
                showFeedback = selectedAnswerIndex != nil
            }
        }
        
        /// Completes the quiz, updates progress, and awards any earned badges.
        private func completeQuiz() {
            let isPerfectScore = correctAnswers == quiz.questions.count
            var newlyEarnedBadges: [BadgeType] = []
            
            // Update quiz completion status
            quizLibraryViewModel.completeQuiz(
                id: quiz.id,
                score: correctAnswers,
                totalQuestions: quiz.questions.count
            )
            
            // Check and award badges
            if isPerfectScore {
                if !badgeProgress.isEarned(.quickLearner) {
                    badgeProgress.earnBadge(.quickLearner)
                    newlyEarnedBadges.append(.quickLearner)
                }
                
                // Check for perfect scores on all quizzes
                let allQuizzesPerfect = quizLibraryViewModel.quizzes.allSatisfy { quiz in
                    quiz.completion == 1.0
                }
                if allQuizzesPerfect && !badgeProgress.isEarned(.safetyScholar) {
                    badgeProgress.earnBadge(.safetyScholar)
                    newlyEarnedBadges.append(.safetyScholar)
                }
            }
            
            quizCompleted = true
            earnedBadges = newlyEarnedBadges
        }
    }
}

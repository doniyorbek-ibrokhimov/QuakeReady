import SwiftUI

/// A view that presents a quiz with multiple-choice questions.
/// Provides navigation between questions, answer feedback, and progress tracking.
struct QuizView: View {
    /// View model managing the quiz state and logic.
    @StateObject private var viewModel: ViewModel
    
    /// Animation transition for content changes.
    private let contentTransition: ContentTransition = .numericText(countsDown: true)
    
    /// Initializes a new quiz view.
    /// - Parameters:
    ///   - quiz: The quiz to be taken
    ///   - badgeProgress: Service for tracking badge achievements
    ///   - quizLibraryViewModel: Parent view model for updating completion status
    init(quiz: Quiz, badgeProgress: BadgeProgress, quizLibraryViewModel: QuizLibraryView.ViewModel) {
        _viewModel = StateObject(wrappedValue: ViewModel(
            quiz: quiz,
            badgeProgress: badgeProgress,
            quizLibraryViewModel: quizLibraryViewModel
        ))
    }
    
    var body: some View {
        VStack(spacing: 32) {
            // Progress indicator
            ProgressDots(totalSteps: viewModel.quiz.questions.count, currentStep: viewModel.currentQuestionIndex + 1)
                .padding(.top)
            
            // Question scenario
            Text(viewModel.quiz.questions[viewModel.currentQuestionIndex].scenario)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                .contentTransition(contentTransition)
            
            // Answer options
            VStack(spacing: 16) {
                ForEach(0..<3) { index in
                    AnswerButton(
                        text: viewModel.quiz.questions[viewModel.currentQuestionIndex].options[index],
                        isSelected: viewModel.selectedAnswerIndex == index,
                        isCorrect: index == viewModel.quiz.questions[viewModel.currentQuestionIndex].correctIndex,
                        showResult: viewModel.showFeedback,
                        action: { viewModel.selectAnswer(index) }
                    )
                    .contentTransition(contentTransition)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Answer feedback
            if viewModel.showFeedback {
                FeedbackView(
                    isCorrect: viewModel.selectedAnswerIndex == viewModel.quiz.questions[viewModel.currentQuestionIndex].correctIndex,
                    feedback: viewModel.quiz.questions[viewModel.currentQuestionIndex].feedback
                )
                .contentTransition(contentTransition)
            }
            
            // Navigation controls
            HStack {
                if viewModel.currentQuestionIndex > 0 {
                    Button(action: viewModel.prevQuestion) {
                        Text("Previous")
                    }
                    .buttonStyle(.secondary)
                }
                
                Button(action: viewModel.nextQuestion) {
                    Text(viewModel.isLastQuestion ? "Complete Quiz" : "Next Question")
                }
                .buttonStyle(.primary(isDisabled: viewModel.selectedAnswerIndex == nil))
            }
        }
        .padding()
        .animation(.easeInOut, value: viewModel.currentQuestionIndex)
        .navigationDestination(isPresented: $viewModel.quizCompleted) {
            QuizSummaryView(
                score: viewModel.correctAnswers,
                total: viewModel.quiz.questions.count,
                earnedBadges: viewModel.earnedBadges
            )
        }
    }
}


import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel: ViewModel
    
    init(quiz: Quiz, badgeProgress: BadgeProgress, quizLibraryViewModel: QuizLibraryView.ViewModel) {
        _viewModel = StateObject(wrappedValue: ViewModel(
            quiz: quiz,
            badgeProgress: badgeProgress,
            quizLibraryViewModel: quizLibraryViewModel
        ))
    }
    
    let contentTransition: ContentTransition = .numericText(countsDown: true)
    
    var body: some View {
        VStack(spacing: 32) {
            // Progress dots
            ProgressDots(totalSteps: viewModel.quiz.questions.count, currentStep: viewModel.currentQuestionIndex + 1)
                .padding(.top)
            
            // Scenario
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
            
            // Feedback
            if viewModel.showFeedback {
                FeedbackView(
                    isCorrect: viewModel.selectedAnswerIndex == viewModel.quiz.questions[viewModel.currentQuestionIndex].correctIndex,
                    feedback: viewModel.quiz.questions[viewModel.currentQuestionIndex].feedback
                )
                .contentTransition(contentTransition)
            }
            
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

struct Question: Hashable {
    let scenario: String
    let options: [String]
    let correctIndex: Int
    let feedback: String
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let showResult: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.body)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 1)
                )
                .cornerRadius(12)
        }
        .disabled(showResult)
    }
    
    private var borderColor: Color {
        guard showResult && isSelected else { return .white }
        return isCorrect ? .green : .red
    }
}

struct FeedbackView: View {
    let isCorrect: Bool
    let feedback: String
    
    var dynamicFeedback: String {
        isCorrect ? "Correct! 🎉" : "Incorrect 😢"
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                
                Text(dynamicFeedback)
            }
            
            Text(feedback)
        }
        .font(.body)
        .foregroundColor(isCorrect ? .green : .red)
        .padding()
    }
}

struct QuizSummaryView: View {
    let score: Int
    let total: Int
    let earnedBadges: [BadgeType]
    
    @EnvironmentObject private var viewModel: QuizLibraryView.ViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Quiz Complete! 🎉")
                .font(.title.bold())
            
            VStack(spacing: 16) {
                Text("\(score)/\(total) Correct")
                Text("Accuracy: \(Int(Double(score) / Double(total) * 100))%")
            }
            .font(.title3)
            
            // Show earned badges if any
            if !earnedBadges.isEmpty {
                VStack(spacing: 12) {
                    ForEach(earnedBadges, id: \.self) { badge in
                        Text("\(badge.title) Badge Earned! 🏅")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
                .transition(.scale.combined(with: .opacity))
            }
            
            Spacer()
            
            Button("Back to Library") {
                viewModel.selectedQuiz = nil
            }
            .buttonStyle(.primary)
        }
        .padding()
        .foregroundColor(.white)
    }
}

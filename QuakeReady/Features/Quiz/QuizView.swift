import SwiftUI

struct QuizView: View {
    let quiz: Quiz
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int?
    @State private var showFeedback = false
    @State private var quizCompleted = false
    @State private var correctAnswers = 0
    
    private var isLastQuestion: Bool {
        currentQuestionIndex == quiz.questions.count - 1
    }
    
    var body: some View {
        VStack(spacing: 32) {
            // Progress dots
            ProgressDots(totalSteps: quiz.questions.count, currentStep: currentQuestionIndex + 1)
                .padding(.top)
            
            // Scenario
            Text(quiz.questions[currentQuestionIndex].scenario)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
            
            // Answer options
            VStack(spacing: 16) {
                ForEach(0..<3) { index in
                    AnswerButton(
                        text: quiz.questions[currentQuestionIndex].options[index],
                        isSelected: selectedAnswerIndex == index,
                        isCorrect: index == quiz.questions[currentQuestionIndex].correctIndex,
                        showResult: showFeedback,
                        action: { selectAnswer(index) }
                    )
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Feedback
            if showFeedback {
                FeedbackView(
                    isCorrect: selectedAnswerIndex == quiz.questions[currentQuestionIndex].correctIndex,
                    feedback: quiz.questions[currentQuestionIndex].feedback
                )
            }
            
            HStack {
                if currentQuestionIndex > 0 {
                    Button(action: prevQuestion) {
                        Text("Previous")
                    }
                    .buttonStyle(.secondary)
                }
                
                Button(action: nextQuestion) {
                    Text(isLastQuestion ? "Complete Quiz" : "Next Question")
                }
                //FIXME: add disabled parameter
                .buttonStyle(.primary(isDisabled: selectedAnswerIndex == nil))
            }
        }
        .animation(.easeInOut, value: currentQuestionIndex)
        .navigationDestination(isPresented: $quizCompleted) {
            QuizSummaryView(score: correctAnswers, total: quiz.questions.count)
        }
    }
    
    private func selectAnswer(_ index: Int) {
        guard !showFeedback else { return }
        selectedAnswerIndex = index
        showFeedback = true
        
        if index == quiz.questions[currentQuestionIndex].correctIndex {
            correctAnswers += 1
        }
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < quiz.questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            showFeedback = false
        } else {
            quizCompleted = true
        }
    }
    
    private func prevQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            selectedAnswerIndex = nil
            showFeedback = false
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
    
    var body: some View {
        HStack {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
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
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: QuizLibraryView.ViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Quiz Complete! 🎉")
                .font(.title)
            
            Text("\(score)/\(total) Correct")
                .font(.title2)
            
            if score == total {
                Text("Perfect Score! 🏅")
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Button("Back to Library") {
//                dismiss()
                viewModel.selectedQuiz = nil
            }
            .buttonStyle(.primary)
        }
        .padding()
    }
}

#Preview {
    QuizView(quiz: Quiz(
        title: "Basic Earthquake Safety",
        icon: "🏠",
        category: "Home Safety",
        questions: [
            Question(
                scenario: "During an earthquake at home, you should",
                options: [
                    "Use elevator to evacuate",
                    "Drop, cover, and hold on",
                    "Call emergency immediately"
                ],
                correctIndex: 1,
                feedback: "Right! Drop, cover, hold is the safest response."
            ),
            Question(
                scenario: "You're in a mall during a quake",
                options: [
                    "Hide under a counter",
                    "Run to the exit",
                    "Stand near windows"
                ],
                correctIndex: 0,
                feedback: "Correct! Stay low and protected."
            ),
            Question(
                scenario: "After an earthquake, you notice gas smell",
                options: [
                    "Light a match to check",
                    "Turn on ventilation",
                    "Exit immediately"
                ],
                correctIndex: 2,
                feedback: "Correct! Leave the area and call authorities."
            )
        ],
        completion: 0.0
    ))
    .preferredColorScheme(.dark)
}

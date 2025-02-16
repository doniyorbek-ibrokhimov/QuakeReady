import SwiftUI

struct Quiz: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let category: String
    let questions: [Question]
    var completion: Double
    var lastAttemptDate: Date?
    var bestScore: Int?
}

struct QuizLibraryView: View {
    @State private var selectedQuiz: Quiz?
    @State private var showingQuiz = false
    
    private let quizzes = [
        Quiz(
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
        ),
        Quiz(
            title: "Public Space Protocols",
            icon: "🛍️",
            category: "Crowded Areas",
            questions: [
                Question(
                    scenario: "You're in a mall during a quake",
                    options: [
                        "Hide under a counter",
                        "Run to the exit",
                        "Stand near windows"
                    ],
                    correctIndex: 0,
                    feedback: "Correct! Stay low and protected."
                )
            ],
            completion: 0.0
        ),
        Quiz(
            title: "Post-Earthquake Actions",
            icon: "⚠️",
            category: "Emergency Response",
            questions: [
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
        )
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Safety Quizzes")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(quizzes) { quiz in
                        QuizCard(quiz: quiz)
                            .onTapGesture {
                                selectedQuiz = quiz
                                showingQuiz = true
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .sheet(isPresented: $showingQuiz) {
            if let quiz = selectedQuiz {
                QuizView(quiz: quiz)
            }
        }
    }
}

struct QuizCard: View {
    let quiz: Quiz
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Text(quiz.icon)
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(quiz.title)
                        .font(.headline)
                    
                    Text(quiz.category)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(quiz.questions.count) Questions • Completed: \(Int(quiz.completion * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ProgressView(value: quiz.completion)
                    .tint(.blue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
} 
import SwiftUI

extension QuizLibraryView {
    class ViewModel: ObservableObject {
        @Published var selectedQuiz: Quiz?
        @Published var showingQuiz = false
        
        let quizzes = [
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
        
        func selectQuiz(_ quiz: Quiz) {
            selectedQuiz = quiz
            showingQuiz = true
        }
    }
} 

import SwiftUI
import SwiftData

extension QuizLibraryView {
    class ViewModel: ObservableObject {
        @Published var selectedQuiz: Quiz?
        @Published var quizzes: [Quiz]
        private var modelContext: ModelContext
        
        // Store quiz IDs as static constants
        private static let basicSafetyQuizId = "Basic Earthquake Safety"
        private static let postQuakeQuizId = "Post-Earthquake Actions"
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            self.quizzes = [
                Quiz(
                    id: Self.basicSafetyQuizId,  // Use title as ID
                    title: Self.basicSafetyQuizId,
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
                    ]
                ),
                Quiz(
                    id: Self.postQuakeQuizId,  // Use title as ID
                    title: Self.postQuakeQuizId,
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
                    ]
                )
            ]
            loadPersistedQuizzes()
        }
        
        private func loadPersistedQuizzes() {
            do {
                let descriptor = FetchDescriptor<QuizAchievement>()
                let achievements = try modelContext.fetch(descriptor)
                
                // Update quizzes with achievement data
                for achievement in achievements {
                    if let index = quizzes.firstIndex(where: { $0.id == achievement.quizId }) {
                        quizzes[index].latestAchievement = achievement
                    }
                }
            } catch {
                print("Failed to fetch quiz achievements: \(error)")
            }
        }
        
        func completeQuiz(id: String, score: Int, totalQuestions: Int) {
            // Create and save achievement
            let achievement = QuizAchievement(
                quizId: id,
                completedDate: Date(),
                score: score,
                totalQuestions: totalQuestions
            )
            modelContext.insert(achievement)
            
            // Update in-memory quiz
            if let index = quizzes.firstIndex(where: { $0.id == id }) {
                quizzes[index].latestAchievement = achievement
            }
            
            do {
                try modelContext.save()
            } catch {
                print("Failed to save quiz achievement: \(error)")
            }
        }
        
        func selectQuiz(_ quiz: Quiz) {
            selectedQuiz = quiz
        }
    }
} 

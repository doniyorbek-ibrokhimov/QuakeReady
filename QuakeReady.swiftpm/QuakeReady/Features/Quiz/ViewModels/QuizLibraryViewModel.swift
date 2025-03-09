import SwiftUI
import SwiftData

extension QuizLibraryView {
    /// View model managing the quiz library's state and business logic.
    /// Handles quiz selection, completion tracking, and achievement persistence.
    class ViewModel: ObservableObject {
        /// Currently selected quiz in the UI, if any.
        @Published var selectedQuiz: Quiz?
        
        /// Array of all available quizzes, including their completion status.
        @Published var quizzes: [Quiz]
        
        /// SwiftData context for persisting quiz achievements.
        private var modelContext: ModelContext
        
        // MARK: - Quiz Identifiers
        
        /// Unique identifier for the basic safety quiz.
        private static let basicSafetyQuizId = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        
        /// Unique identifier for the post-earthquake quiz.
        private static let postQuizId = UUID(uuidString: "F621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        
        /// Unique identifier for the elevator safety quiz.
        private static let elevatorQuizId = UUID(uuidString: "F621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        
        /// Unique identifier for the crowd safety quiz.
        private static let crowdSafetyQuizId = UUID(uuidString: "A621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
        
        /// Initializes the quiz library view model.
        /// - Parameter modelContext: SwiftData context for persistence
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            self.quizzes = [
                Quiz(
                    id: Self.basicSafetyQuizId,
                    title: "Basic Drop-Cover-Hold",
                    icon: "⚠️",
                    category: "Basic Safety",
                    questions: [
                        Question(
                            scenario: "When you first feel earthquake shaking, what's your immediate action?",
                            options: [
                                "Run outside quickly",
                                "Drop to the ground",
                                "Call emergency services"
                            ],
                            correctIndex: 1,
                            feedback: "Drop to the ground immediately to prevent falling"
                        ),
                        Question(
                            scenario: "After dropping, what should you do to protect your head?",
                            options: [
                                "Cover head with hands only",
                                "Get under sturdy furniture",
                                "Use a pillow or cushion"
                            ],
                            correctIndex: 1,
                            feedback: "A sturdy desk or table provides the best protection"
                        ),
                        Question(
                            scenario: "While under cover, why is it important to hold on?",
                            options: [
                                "To stay warm",
                                "To prevent shelter movement",
                                "To feel less scared"
                            ],
                            correctIndex: 1,
                            feedback: "Hold on to prevent your shelter from moving away during shaking"
                        )
                    ]
                ),
                Quiz(
                    id: Self.elevatorQuizId,
                    title: "Elevator Emergency",
                    icon: "🛗",
                    category: "Building Safety",
                    questions: [
                        Question(
                            scenario: "If you're in an elevator when an earthquake starts, what's your first action?",
                            options: [
                                "Press all floor buttons",
                                "Call for help on intercom",
                                "Wait for rescue"
                            ],
                            correctIndex: 0,
                            feedback: "Press all buttons to increase chances of stopping at nearest floor"
                        ),
                        Question(
                            scenario: "While the elevator is moving, how should you position yourself?",
                            options: [
                                "Sit on the floor",
                                "Brace against the wall",
                                "Stand in the center"
                            ],
                            correctIndex: 1,
                            feedback: "Brace against the wall to maintain stability"
                        ),
                        Question(
                            scenario: "Once the elevator stops, what's your priority?",
                            options: [
                                "Call emergency services",
                                "Exit immediately",
                                "Check phone signals"
                            ],
                            correctIndex: 1,
                            feedback: "Exit as soon as possible to avoid being trapped"
                        )
                    ]
                ),
                Quiz(
                    id: Self.crowdSafetyQuizId,
                    title: "Crowd Safety Protocol",
                    icon: "👥",
                    category: "Public Safety",
                    questions: [
                        Question(
                            scenario: "In a crowded space during an earthquake, what's your first priority?",
                            options: [
                                "Follow the crowd",
                                "Stay calm and assess",
                                "Call for help"
                            ],
                            correctIndex: 1,
                            feedback: "Staying calm helps you make better decisions"
                        ),
                        Question(
                            scenario: "When moving away from crowds, what should you avoid?",
                            options: [
                                "Open spaces",
                                "Emergency exits",
                                "Glass windows/facades"
                            ],
                            correctIndex: 2,
                            feedback: "Glass can shatter during earthquakes"
                        ),
                        Question(
                            scenario: "What's the best type of shelter in a crowded building?",
                            options: [
                                "Against interior walls",
                                "Near exit doors",
                                "Under decorative elements"
                            ],
                            correctIndex: 0,
                            feedback: "Interior walls provide better structural support"
                        )
                    ]
                )
            ]
            loadPersistedQuizzes()
        }
        
        /// Loads previously completed quiz achievements from persistent storage
        /// and updates the in-memory quiz array with achievement data.
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
        
        /// Records the completion of a quiz and persists the achievement.
        /// - Parameters:
        ///   - id: The unique identifier of the completed quiz
        ///   - score: The number of correct answers
        ///   - totalQuestions: The total number of questions in the quiz
        func completeQuiz(id: UUID, score: Int, totalQuestions: Int) {
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
        
        /// Sets the currently selected quiz.
        /// - Parameter quiz: The quiz to select
        func selectQuiz(_ quiz: Quiz) {
            selectedQuiz = quiz
        }
    }
} 

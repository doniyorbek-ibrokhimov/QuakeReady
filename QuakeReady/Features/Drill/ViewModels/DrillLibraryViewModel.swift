import SwiftUI
import SwiftData

extension DrillLibraryView {
    /// View model responsible for managing the drill library's state and business logic.
    class ViewModel: ObservableObject {
        /// Currently selected drill in the UI, if any.
        @Published var selectedDrill: Drill?
        
        /// Array of all available drills, including their completion status.
        @Published var drills: [Drill]
        
        /// SwiftData context for persisting drill achievements.
        private var modelContext: ModelContext
        
        /// Initializes the view model with a SwiftData context.
        /// - Parameter modelContext: The SwiftData context for persistence
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            self.drills = [
                Drill(
                    type: .basic,
                    title: "Basic Drop-Cover-Hold",
                    icon: "⚠️",
                    duration: 30,
                    difficulty: .beginner,
                    description: "The Drop-Cover-Hold technique is your first line of defense during an earthquake. This drill teaches you how to quickly get to the ground, find appropriate cover, and maintain your position until the shaking stops. This fundamental skill can prevent injuries from falling objects and collapsing structures.",
                    steps: ["Drop to the ground", "Cover your head", "Hold on"],
                    instructions: [
                        [
                            Instruction(text: "Move away from windows", isWarning: false),
                            Instruction(text: "Find clear space", isWarning: false)
                        ],
                        [
                            Instruction(text: "Protect head and neck", isWarning: false),
                            Instruction(text: "Keep distance from furniture", isWarning: true)
                        ],
                        [
                            Instruction(text: "Hold onto stable object", isWarning: false),
                            Instruction(text: "Stay in position until shaking stops", isWarning: false)
                        ]
                    ],
                    isNew: false
                ),
                Drill(
                    type: .elevator,
                    title: "Elevator Safety Protocol",
                    icon: "🛗",
                    duration: 45,
                    difficulty: .intermediate,
                    description: "Being trapped in an elevator during an earthquake can be dangerous. This drill focuses on quick evacuation techniques and proper positioning while inside. Learn how to use elevator emergency features and protect yourself if stuck between floors.",
                    steps: ["Press all floor buttons", "Brace against wall", "Exit quickly when possible"],
                    instructions: [
                        [
                            Instruction(text: "Press emergency button", isWarning: false),
                            Instruction(text: "Remain calm and alert", isWarning: false)
                        ],
                        [
                            Instruction(text: "Brace against walls", isWarning: false),
                            Instruction(text: "Stay clear of elevator doors", isWarning: true)
                        ],
                        [
                            Instruction(text: "Wait for door status check", isWarning: false),
                            Instruction(text: "Exit only when confirmed safe", isWarning: true)
                        ]
                    ],
                    isNew: true
                ),
                Drill(
                    type: .crowd,
                    title: "Crowded Space Protocol",
                    icon: "👥",
                    duration: 60,
                    difficulty: .advanced,
                    description: "Earthquakes in crowded spaces present unique challenges. This drill teaches you how to navigate through crowds safely, identify secure shelter spots in public buildings, and avoid common hazards like glass facades and decorative elements that may fall during shaking.",
                    steps: ["Stay calm", "Move away from crowds", "Find stable shelter"],
                    instructions: [
                        [
                            Instruction(text: "Control your breathing", isWarning: false),
                            Instruction(text: "Survey your surroundings", isWarning: false)
                        ],
                        [
                            Instruction(text: "Move calmly and steadily", isWarning: false),
                            Instruction(text: "Keep away from glass windows", isWarning: true)
                        ],
                        [
                            Instruction(text: "Locate an interior wall", isWarning: false),
                            Instruction(text: "Avoid overhead decorations", isWarning: true)
                        ]
                    ],
                    isNew: true
                )
            ]
            loadPersistedDrills()
        }
        
        /// Loads previously completed drills from persistent storage and updates the in-memory drill array.
        private func loadPersistedDrills() {
            do {
                let descriptor = FetchDescriptor<DrillAchievement>()
                let achievements = try modelContext.fetch(descriptor)
                
                // Update drills with completion data
                for achievement in achievements {
                    if let drillType = DrillType(rawValue: achievement.drillType),
                       let index = drills.firstIndex(where: { $0.type == drillType }) {
                        drills[index].lastCompleted = achievement.completedDate
                    }
                }
            } catch {
                print("Failed to fetch drill achievements: \(error)")
            }
        }
        
        /// Records the completion of a drill and persists the achievement.
        /// - Parameters:
        ///   - type: The type of drill completed
        ///   - date: The completion timestamp
        ///   - accuracy: The user's accuracy score (0-100)
        ///   - timeTaken: The time taken to complete the drill in seconds
        func completeDrill(type: DrillType, date: Date, accuracy: Double, timeTaken: Int) {
            // Update in-memory drill
            if let index = drills.firstIndex(where: { $0.type == type }) {
                drills[index].lastCompleted = date
            }
            
            // Persist to SwiftData
            let achievement = DrillAchievement(
                drillType: type.rawValue,
                completedDate: date,
                accuracy: accuracy,
                timeTaken: timeTaken
            )
            modelContext.insert(achievement)
            
            do {
                try modelContext.save()
            } catch {
                print("Failed to save drill achievement: \(error)")
            }
        }
        
        /// Array of drills that have been completed at least once.
        var recentDrills: [Drill] {
            drills.filter { $0.lastCompleted != nil }
        }
    }
}

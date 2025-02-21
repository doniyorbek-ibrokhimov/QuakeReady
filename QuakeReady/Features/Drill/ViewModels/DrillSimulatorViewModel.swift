import SwiftUI

extension DrillLibraryView.DrillSimulatorView {
    /// View model responsible for managing the state and logic of an active drill simulation.
    class ViewModel: ObservableObject {
        /// The drill being simulated.
        let drill: Drill
        
        /// Service for tracking and awarding badge progress.
        private let badgeProgress: BadgeProgress
        
        /// Parent view model for updating drill completion status.
        private let drillLibraryViewModel: DrillLibraryView.ViewModel
        
        /// Current step number in the drill simulation (1-3).
        @Published var currentStep = 1
        
        /// Indicates whether the drill timer is currently running.
        @Published var isTimerRunning = false
        
        /// Controls the visibility of the post-drill summary screen.
        @Published var showSummary = false
        
        /// The accuracy score achieved in the drill (0.0-1.0).
        @Published var drillAccuracy: Double = 0.9
        
        /// Total time taken to complete the drill in seconds.
        @Published var totalTimeTaken = 0
        
        /// Initializes a new drill simulator view model.
        /// - Parameters:
        ///   - drill: The drill to simulate
        ///   - badgeProgress: Service for tracking badge achievements
        ///   - drillLibraryViewModel: Parent view model for updating completion status
        init(drill: Drill, 
             badgeProgress: BadgeProgress,
             drillLibraryViewModel: DrillLibraryView.ViewModel) {
            self.drill = drill
            self.badgeProgress = badgeProgress
            self.drillLibraryViewModel = drillLibraryViewModel
        }
        
        /// Advances to the next step in the drill or completes it if on the final step.
        func nextStep() {
            if currentStep < 3 {
                currentStep += 1
            } else {
                isTimerRunning = false
                completeDrill()
            }
        }
        
        /// Returns to the previous step in the drill if possible.
        func prevStep() {
            if currentStep > 0 {
                currentStep -= 1
            } else {
                isTimerRunning = false
            }
        }
        
        /// Completes the drill, calculates performance metrics, and awards badges if earned.
        private func completeDrill() {
            drillAccuracy = min(1.0, Double(drill.duration) / Double(totalTimeTaken))
            
            drillLibraryViewModel.completeDrill(
                type: drill.type,
                date: Date(),
                accuracy: drillAccuracy,
                timeTaken: totalTimeTaken
            )
            
            let completedDrills = drillLibraryViewModel.recentDrills.count
            
            if completedDrills >= 3 {
                badgeProgress.earnBadge(.drillMaster)
            } else if completedDrills >= 1 {
                badgeProgress.earnBadge(.drillBeginner)
            }
            
            showSummary = true
        }
    }
} 

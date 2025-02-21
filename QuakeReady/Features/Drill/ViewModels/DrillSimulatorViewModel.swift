import SwiftUI

extension DrillLibraryView.DrillSimulatorView {
    class ViewModel: ObservableObject {
        let drill: Drill
        private let badgeProgress: BadgeProgress
        private let drillLibraryViewModel: DrillLibraryView.ViewModel
        
        @Published var currentStep = 1
        @Published var isTimerRunning = false
        @Published var showSummary = false
        @Published var drillAccuracy: Double = 0.9
        @Published var totalTimeTaken = 0
        
        init(drill: Drill, 
             badgeProgress: BadgeProgress,
             drillLibraryViewModel: DrillLibraryView.ViewModel) {
            self.drill = drill
            self.badgeProgress = badgeProgress
            self.drillLibraryViewModel = drillLibraryViewModel
        }
        
        func nextStep() {
            if currentStep < 3 {
                currentStep += 1
            } else {
                isTimerRunning = false
                completeDrill()
            }
        }
        
        func prevStep() {
            if currentStep > 0 {
                currentStep -= 1
            } else {
                isTimerRunning = false
            }
        }
        
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

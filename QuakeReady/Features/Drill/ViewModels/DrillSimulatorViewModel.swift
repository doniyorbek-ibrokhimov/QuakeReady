import SwiftUI

extension DrillLibraryView.DrillSimulatorView {
    class ViewModel: ObservableObject {
        let drill: Drill
        private let badgeProgress: BadgeProgress
        private let drillLibraryViewModel: DrillLibraryView.ViewModel
        
        @Published var currentStep = 1
        @Published var timeRemaining: Int
        @Published var isTimerRunning = false
        @Published var showSummary = false
        @Published var drillAccuracy: Double = 0.9
        @Published var totalTimeTaken = 0
        @Published var shakeIntensity: Double = 0.0
        @Published var environmentOpacity = 0.0
        
        init(drill: Drill, 
             badgeProgress: BadgeProgress,
             drillLibraryViewModel: DrillLibraryView.ViewModel) {
            self.drill = drill
            self.badgeProgress = badgeProgress
            self.drillLibraryViewModel = drillLibraryViewModel
            self.timeRemaining = drill.duration
        }
        
        func startSimulation() {
            startTimer()
            animateEnvironment()
        }
        
        func updateIntensity() {
            withAnimation(.easeInOut(duration: 1)) {
                shakeIntensity = Double(timeRemaining) / Double(drill.duration)
            }
        }
        
        func nextStep() {
            if currentStep < 3 {
                currentStep += 1
                timeRemaining = 10
                startTimer()
            } else {
                isTimerRunning = false
                completeDrill()
            }
        }
        
        func prevStep() {
            if currentStep > 0 {
                currentStep -= 1
                timeRemaining = 10
                startTimer()
            } else {
                isTimerRunning = false
            }
        }
        
        private func startTimer() {
            isTimerRunning = true
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                if self.timeRemaining > 0 && self.isTimerRunning {
                    self.timeRemaining -= 1
                    self.totalTimeTaken += 1
                } else {
                    timer.invalidate()
                }
            }
        }
        
        private func animateEnvironment() {
            withAnimation(.easeIn(duration: 0.5)) {
                environmentOpacity = 1.0
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

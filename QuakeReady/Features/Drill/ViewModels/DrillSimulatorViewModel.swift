import SwiftUI
import CoreHaptics
import AVFoundation

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
        
        private var hapticEngine: CHHapticEngine?
        private var audioPlayer: AVAudioPlayer?
        
        init(drill: Drill, 
             badgeProgress: BadgeProgress,
             drillLibraryViewModel: DrillLibraryView.ViewModel) {
            self.drill = drill
            self.badgeProgress = badgeProgress
            self.drillLibraryViewModel = drillLibraryViewModel
            self.timeRemaining = drill.duration
            prepareHaptics()
            loadAudioEffects()
        }
        
        func startSimulation() {
            startTimer()
            animateEnvironment()
            playBackgroundAudio()
        }
        
        func updateIntensity() {
            withAnimation(.easeInOut(duration: 1)) {
                shakeIntensity = Double(timeRemaining) / Double(drill.duration)
            }
            triggerHapticFeedback()
        }
        
        func nextStep() {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
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
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
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
        
        private func prepareHaptics() {
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
            
            do {
                hapticEngine = try CHHapticEngine()
                try hapticEngine?.start()
            } catch {
                print("Haptic engine creation error: \(error)")
            }
        }
        
        private func triggerHapticFeedback() {
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
                  let engine = hapticEngine else { return }
            
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                               value: Float(shakeIntensity))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                               value: Float(shakeIntensity))
            
            let event = CHHapticEvent(eventType: .hapticContinuous,
                                  parameters: [intensity, sharpness],
                                  relativeTime: 0,
                                  duration: 0.5)
            
            do {
                let pattern = try CHHapticPattern(events: [event], parameters: [])
                let player = try engine.makePlayer(with: pattern)
                try player.start(atTime: 0)
            } catch {
                print("Failed to play pattern: \(error)")
            }
        }
        
        private func loadAudioEffects() {
            guard let url = Bundle.main.url(forResource: "earthquake_rumble",
                                        withExtension: "mp3") else { return }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Failed to load audio: \(error)")
            }
        }
        
        private func playBackgroundAudio() {
            audioPlayer?.setVolume(0, fadeDuration: 0)
            audioPlayer?.play()
            audioPlayer?.setVolume(Float(shakeIntensity), fadeDuration: 1.0)
        }
        
        private func completeDrill() {
            // Calculate accuracy based on timing and steps completed
            drillAccuracy = min(1.0, Double(drill.duration) / Double(totalTimeTaken))
            
            // Save drill completion
            drillLibraryViewModel.completeDrill(
                type: drill.type,
                date: Date(),
                accuracy: drillAccuracy,
                timeTaken: totalTimeTaken
            )
            
            // Check and award badges
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

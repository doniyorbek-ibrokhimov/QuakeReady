import SwiftUI
import CoreHaptics
import AVFoundation

extension DrillLibraryView {
    struct DrillSimulatorView: View {
        let drill: Drill
        
        @State private var currentStep = 1
        @State private var timeRemaining: Int
        @State private var isTimerRunning = false
        @State private var showSummary = false
        @State private var drillAccuracy: Double = 0.9
        @State private var totalTimeTaken = 0
        @State private var hapticEngine: CHHapticEngine?
        @State private var shakeIntensity: Double = 0.0
        @State private var audioPlayer: AVAudioPlayer?
        
        // Environment background states
        @State private var environmentOpacity = 0.0
        
        init(drill: Drill) {
            self.drill = drill
            _timeRemaining = State(initialValue: drill.duration)
            prepareHaptics()
            loadAudioEffects()
        }
        
        var body: some View {
            NavigationStack {
                content
                    .animation(.easeInOut, value: currentStep)
                    .navigationDestination(isPresented: $showSummary) {
                        DrillSummaryView(accuracy: drillAccuracy, timeTaken: totalTimeTaken)
                    }
            }
            .onAppear {
                startSimulation()
            }
            .onChange(of: timeRemaining) { _ in
                updateIntensity()
            }
        }
        
        private var content: some View {
            ZStack {
                // Environment Layer
//                EnvironmentView(drill: drill, intensity: shakeIntensity)
//                    .opacity(environmentOpacity)
                
                // Main Content
                VStack(spacing: 32) {
                    // Intensity Meter
                    IntensityMeter(value: shakeIntensity)
                        .frame(width: 120, height: 120)
                    
                    // Interactive Character
//                    CharacterView(step: currentStep)
//                        .frame(height: 200)
                    
                    // Step Instructions
                    InstructionCard(
                        step: currentStep,
                        text: drill.steps[currentStep - 1],
                        timeRemaining: timeRemaining
                    )
                    
                    Spacer()
                    
                    // Action Button
                    HStack {
                        
                        if currentStep > 1 {
                            Button("Previous Step") {
                                prevStep()
                            }
                            .buttonStyle(.secondary)
                        }
                        
                        ActionButton(
                            currentStep: currentStep,
                            action: nextStep
                        )
                    }
                }
                .padding()
            }
        }
        
        private func startSimulation() {
            startTimer()
            animateEnvironment()
            playBackgroundAudio()
        }
        
        private func updateIntensity() {
            withAnimation(.easeInOut(duration: 1)) {
                shakeIntensity = Double(timeRemaining) / Double(drill.duration)
            }
            triggerHapticFeedback()
        }
        
        private func startTimer() {
            isTimerRunning = true
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if timeRemaining > 0 && isTimerRunning {
                    timeRemaining -= 1
                    totalTimeTaken += 1
                } else {
                    timer.invalidate()
                }
            }
        }
        
        private func nextStep() {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            if currentStep < 3 {
                currentStep += 1
                timeRemaining = 10
                startTimer()
            } else {
                isTimerRunning = false
                showSummary = true
            }
        }
        
        private func prevStep() {
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
    }
}



import SwiftUI

extension DrillLibraryView {
    struct DrillSimulatorView: View {
        let drill: Drill
        
        @State private var currentStep = 1
        @State private var timeRemaining: Int
        @State private var isTimerRunning = false
        @State private var showSummary = false
        @State private var drillAccuracy: Double = 0.9
        @State private var totalTimeTaken = 0
        
        init(drill: Drill) {
            self.drill = drill
            _timeRemaining = State(initialValue: drill.duration)
        }
        
        // MARK: - Body
        var body: some View {
            VStack(spacing: 32) {
                // Progress dots
                ProgressDots(totalSteps: 3, currentStep: currentStep)
                    .padding(.top)
                
                // Timer
                ZStack {
                    Circle()
                        .stroke(lineWidth: 4)
                        .opacity(0.3)
                        .foregroundColor(.blue)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / 10)
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(timeRemaining)")
                        .font(.system(size: 36, weight: .medium, design: .monospaced))
                }
                .frame(width: 100, height: 100)
                
                // Step Progress
                ProgressView(value: 0.7)
                    .frame(height: 200)
                    .accessibilityLabel(drill.steps[currentStep - 1])
                
                // Step text
                Text("Step \(currentStep): \(drill.steps[currentStep - 1])")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Next button
                Button(action: nextStep) {
                    Text(currentStep == 3 ? "Finish" : "Next Step")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .onAppear(perform: startTimer)
            .sheet(isPresented: $showSummary) {
                DrillSummaryView(accuracy: drillAccuracy, timeTaken: totalTimeTaken)
            }
        }
        
        // MARK: - Methods
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
    }
}



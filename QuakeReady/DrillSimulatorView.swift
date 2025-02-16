import SwiftUI

struct DrillSimulatorView: View {
    // MARK: - Properties
    @State private var currentStep = 1
    @State private var timeRemaining = 10
    @State private var isTimerRunning = false
    @State private var showSummary = false
    @State private var drillAccuracy: Double = 0.9 // Mock accuracy
    @State private var totalTimeTaken = 0
    
    private let steps = [
        "Drop to the ground",
        "Cover your head",
        "Hold on"
    ]
    
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
                .accessibilityLabel(steps[currentStep - 1])
            
            // Step text
            Text("Step \(currentStep): \(steps[currentStep - 1])")
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

// MARK: - Supporting Views
struct ProgressDots: View {
    let totalSteps: Int
    let currentStep: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                Circle()
                    .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 12, height: 12)
            }
        }
    }
}

struct DrillSummaryView: View {
    let accuracy: Double
    let timeTaken: Int
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Drill Complete! 🎉")
                .font(.title.bold())
            
            VStack(spacing: 16) {
                Text("Time Taken: \(timeTaken)s")
                Text("Accuracy: \(Int(accuracy * 100))%")
            }
            .font(.title3)
            
            Text("Drilliant Badge Earned! 🏅")
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding()
    }
}

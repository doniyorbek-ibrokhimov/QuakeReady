import SwiftUI

/// A circular timer view that shows remaining time and progress during a drill.
/// The circle fills counter-clockwise and changes color based on progress.
struct TimerView: View {
    /// The number of seconds remaining in the timer.
    @State private var timeRemaining: Int
    
    /// The progress value of the timer (0.0-1.0).
    @State private var value: CGFloat = 0
    
    /// View model for managing the drill simulation state.
    @EnvironmentObject private var viewModel: DrillLibraryView.DrillSimulatorView.ViewModel
    
    /// Initializes a new timer view.
    /// - Parameter timeRemaining: Initial number of seconds for the countdown
    init(timeRemaining: Int) {
        self.timeRemaining = timeRemaining
    }
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
            
            // Progress Circle - fills counter-clockwise
            Circle()
                .trim(from: 0, to: value)
                .stroke(progressColor, style: StrokeStyle(
                    lineWidth: 8,
                    lineCap: .round
                ))
                .rotationEffect(.degrees(-90))
            
            // Time Display
            VStack(spacing: 4) {
                Text("\(timeRemaining)")
                    .contentTransition(.numericText())
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                
                Text("seconds")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .onAppear(perform: startTimer)
    }
    
    /// Returns the appropriate color based on the current progress value.
    /// - Red: 0-40% progress
    /// - Yellow: 40-70% progress
    /// - Green: 70-100% progress
    private var progressColor: Color {
        switch value {
        case 0.0..<0.4: return .red
        case 0.4..<0.7: return .yellow
        default: return .green
        }
    }
    
    /// Starts the countdown timer and updates the progress circle.
    /// Updates every second and stops when the timer is no longer running.
    private func startTimer() {
        viewModel.isTimerRunning = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            guard self.viewModel.isTimerRunning else {
                timer.invalidate()
                return
            }
            
            if self.timeRemaining > 0 {
                withAnimation {
                    self.timeRemaining -= 1
                    self.value = CGFloat(self.timeRemaining) / CGFloat(viewModel.drill.duration)
                }
            }
            self.viewModel.totalTimeTaken += 1
        }
    }
}

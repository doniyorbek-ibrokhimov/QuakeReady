import SwiftUI

struct TimerView: View {
    @State private var timeRemaining: Int
    @State private var value: CGFloat = 0
    
    init(timeRemaining: Int) {
        self.timeRemaining = timeRemaining
    }
    
    @EnvironmentObject private var viewModel: DrillLibraryView.DrillSimulatorView.ViewModel
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
            
            // Value Circle
            Circle()
                .trim(from: 0, to: value)
                .stroke(progressColor, style: StrokeStyle(
                    lineWidth: 8,
                    lineCap: .round
                ))
                .rotationEffect(.degrees(-90))
            
            // Center Text
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
    
    private var progressColor: Color {
        switch value {
        case 0.0..<0.4: return .red
        case 0.4..<0.7: return .yellow
        default: return .green
        }
    }
    
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

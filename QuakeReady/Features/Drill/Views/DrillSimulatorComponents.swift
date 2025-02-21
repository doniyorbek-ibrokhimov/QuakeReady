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
            if self.timeRemaining > 0 && self.viewModel.isTimerRunning {
                withAnimation {
                    self.timeRemaining -= 1
                    self.value = CGFloat(self.timeRemaining) / CGFloat(viewModel.drill.duration)
                }
                self.viewModel.totalTimeTaken += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Instruction Card
struct InstructionCard: View {
    let step: Int
    let text: String
    let checklistItems: [[ChecklistItem]]
    
    init(step: Int, text: String, checklistItems: [[ChecklistItem]]) {
        self.step = step
        self.text = text
        self.checklistItems = checklistItems
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Step \(step)")
                .font(.headline)
                .foregroundColor(.blue)
            
            Text(text)
                .font(.title3)
                .multilineTextAlignment(.center)
            
            // Checklist Items
            if let checks = checklistItems[safe: step - 1] {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(checks, id: \.self) { item in
                        Label(item.text, systemImage: item.done ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(item.done ? .green : .red)
                    }
                }
                .font(.callout)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

// MARK: - Supporting Types
struct ChecklistItem: Hashable {
    let text: String
    let done: Bool
}

// MARK: - Action Button
struct ActionButton: View {
    let currentStep: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(currentStep < 3 ? "Next Step" : "Complete Drill")
        }
        .buttonStyle(.primary)
    }
}

// MARK: - Primary Button Style
struct PrimaryButtonStyle: ButtonStyle {
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .opacity(isDisabled ? 0.5 : 1.0)
            .disabled(isDisabled)
            .allowsHitTesting(!isDisabled)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        primary()
    }
    
    static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
    
    static func primary(isDisabled: Bool = false) -> PrimaryButtonStyle {
        PrimaryButtonStyle(isDisabled: isDisabled)
    }
}

// MARK: - Secondary Button Style
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}


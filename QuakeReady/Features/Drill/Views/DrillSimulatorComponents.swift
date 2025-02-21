import SwiftUI
import SpriteKit

// MARK: - Environment View
struct EnvironmentView: View {
    let drill: Drill
    let intensity: Double
    
    @State private var particleSystem = SKEmitterNode()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Scene
                Image(backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .modifier(ShakeEffect(animatableData: intensity))
                
                // Debris Particles
                SpriteView(scene: createDebrisScene(size: geometry.size))
                    .opacity(intensity > 0.5 ? 0.5 : 0)
                
                // Cracks Overlay
                CracksView(intensity: intensity)
            }
        }
    }
    
    private var backgroundImage: String {
        switch drill.type {
        case .basic: return "room_background"
        case .elevator: return "elevator_background"
        case .crowd: return "mall_background"
        }
    }
    
    private func createDebrisScene(size: CGSize) -> SKScene {
        let scene = SKScene(size: size)
        scene.backgroundColor = .clear
        scene.scaleMode = .fill
        
        if let emitter = SKEmitterNode(fileNamed: "DebrisParticles") {
            emitter.position = CGPoint(x: size.width/2, y: size.height)
            emitter.particleAlpha = CGFloat(intensity)
            scene.addChild(emitter)
        }
        
        return scene
    }
}

// MARK: - Intensity Meter
struct IntensityMeter: View {
    let value: Double
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
            
            // Value Circle
            Circle()
                .trim(from: 0, to: value)
                .stroke(intensityColor, style: StrokeStyle(
                    lineWidth: 8,
                    lineCap: .round
                ))
                .rotationEffect(.degrees(-90))
            
            // Center Text
            VStack {
                Text(String(format: "%.1f", 3 + (value * 3.5)))
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .contentTransition(.numericText())
                Text("Magnitude")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var intensityColor: Color {
        switch value {
        case 0.0..<0.4: return .green
        case 0.4..<0.7: return .yellow
        default: return .red
        }
    }
}

// MARK: - Character View
struct CharacterView: View {
    let step: Int
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Character Figure
            characterImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1)) {
                        rotation += 360
                    }
                }
        }
    }
    
    private var characterImage: Image {
        switch step {
        case 1: return Image("character_standing")
        case 2: return Image("character_crawling")
        case 3: return Image("character_holding")
        default: return Image("character_standing")
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
    let timeRemaining: Int
    
    init(step: Int, text: String, timeRemaining: Int) {
        self.step = step
        self.text = text
        self.timeRemaining = timeRemaining
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
    
    private var checklistItems: [[ChecklistItem]] = [
        [
            ChecklistItem(text: "Move away from windows", done: true),
            ChecklistItem(text: "Find clear space", done: true)
        ],
        [
            ChecklistItem(text: "Protect head and neck", done: true),
            ChecklistItem(text: "Stay away from furniture", done: false)
        ],
        [
            ChecklistItem(text: "Grip stable object", done: true),
            ChecklistItem(text: "Maintain position", done: true)
        ]
    ]
}

// MARK: - Supporting Types
struct ChecklistItem: Hashable {
    let text: String
    let done: Bool
}

struct ShakeEffect: GeometryEffect {
    var animatableData: Double
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let shake = animatableData * 10
        let translation = CGFloat(sin(shake * .pi * 2) * 5)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

// MARK: - Cracks View
struct CracksView: View {
    let intensity: Double
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<Int(intensity * 5), id: \.self) { index in
                Path { path in
                    let startX = CGFloat.random(in: 0...geometry.size.width)
                    let startY = CGFloat.random(in: 0...geometry.size.height)
                    path.move(to: CGPoint(x: startX, y: startY))
                    
                    for _ in 0..<3 {
                        let endX = startX + CGFloat.random(in: -50...50)
                        let endY = startY + CGFloat.random(in: -50...50)
                        path.addLine(to: CGPoint(x: endX, y: endY))
                    }
                }
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
            }
        }
        .opacity(intensity > 0.7 ? Double(intensity) : 0)
    }
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


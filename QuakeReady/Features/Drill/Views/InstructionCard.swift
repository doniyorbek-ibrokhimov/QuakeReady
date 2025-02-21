//
//  InstructionCard.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A card view that displays step-specific instructions during a drill.
/// Shows the step number, description, and a list of actions or warnings.
struct InstructionCard: View {
    /// The current step number in the drill sequence.
    let step: Int
    
    /// The main descriptive text for this step.
    let text: String
    
    /// Array of instruction arrays, where each sub-array contains
    /// the specific instructions for a single step.
    let instructions: [[Instruction]]
    
    /// Initializes a new instruction card.
    /// - Parameters:
    ///   - step: The current step number (1-based index)
    ///   - text: The main descriptive text for this step
    ///   - instructions: Nested array of instructions, where each sub-array corresponds to a step
    init(step: Int, text: String, instructions: [[Instruction]]) {
        self.step = step
        self.text = text
        self.instructions = instructions
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Step \(step)")
                .font(.headline)
                .foregroundColor(.blue)
            
            Text(text)
                .font(.title3)
                .multilineTextAlignment(.center)
            
            // Instructions
            if let instructions = instructions[safe: step - 1] {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(instructions, id: \.self) { item in
                        Label(
                            title: { Text(item.text) },
                            icon: {
                                Image(systemName: item.isWarning ? "exclamationmark.triangle.fill" : "arrow.right.circle.fill")
                            }
                        )
                        .foregroundColor(item.isWarning ? .orange : .green)
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

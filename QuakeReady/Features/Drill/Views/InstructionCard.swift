//
//  InstructionCard.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

struct InstructionCard: View {
    let step: Int
    let text: String
    let instructions: [[Instruction]]
    
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

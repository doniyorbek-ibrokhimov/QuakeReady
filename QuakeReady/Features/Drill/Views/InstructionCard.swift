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
            
            // Instructions
            if let instructions = checklistItems[safe: step - 1] {
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

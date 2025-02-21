//
//  AnswerButton.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

struct AnswerButton: View {
    /// The text displayed on the button.
    let text: String
    
    /// Whether the button is currently selected by the user.
    let isSelected: Bool
    
    /// Whether the button represents the correct answer.
    let isCorrect: Bool
    
    /// Whether the result is being shown after the user has answered.
    let showResult: Bool
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.body)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 1)
                )
                .cornerRadius(12)
        }
        .disabled(showResult)
    }
    
    private var borderColor: Color {
        guard showResult && isSelected else { return .white }
        return isCorrect ? .green : .red
    }
}

//
//  FeedbackView.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

struct FeedbackView: View {
    let isCorrect: Bool
    let feedback: String
    
    var dynamicFeedback: String {
        isCorrect ? "Correct! 🎉" : "Incorrect 😢"
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                
                Text(dynamicFeedback)
            }
            
            Text(feedback)
                .multilineTextAlignment(.center)
        }
        .font(.body)
        .foregroundColor(isCorrect ? .green : .red)
        .padding()
    }
}

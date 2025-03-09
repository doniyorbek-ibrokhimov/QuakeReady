//
//  QuizCard.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

struct QuizCard: View {
    /// The quiz model containing quiz details.
    let quiz: Quiz
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Text(quiz.icon)
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(quiz.title)
                        .font(.headline)
                    
                    Text(quiz.category)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Group {
                    grammarCorrectedText(count: quiz.questions.count, baseString: "Question")
                    +
                    Text(" • Completed: \(Int(quiz.completion * 100))%")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                ProgressView(value: quiz.completion)
                    .tint(.blue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

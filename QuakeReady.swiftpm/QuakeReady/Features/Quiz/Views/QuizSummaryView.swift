//
//  QuizSummaryView.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

struct QuizSummaryView: View {
    /// The score achieved by the user.
    let score: Int
    
    /// The total number of questions in the quiz.
    let total: Int
    
    /// The badges earned by the user during this quiz session.
    let earnedBadges: [BadgeType]
    
    @EnvironmentObject private var viewModel: QuizLibraryView.ViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Quiz Complete! 🎉")
                .font(.title.bold())
            
            VStack(spacing: 16) {
                Text("\(score)/\(total) Correct")
                Text("Accuracy: \(Int(Double(score) / Double(total) * 100))%")
            }
            .font(.title3)
            
            // Show earned badges if any
            if !earnedBadges.isEmpty {
                VStack(spacing: 12) {
                    ForEach(earnedBadges, id: \.self) { badge in
                        Text("\(badge.title) Badge Earned! 🏅")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
                .transition(.scale.combined(with: .opacity))
            }
            
            Spacer()
            
            Button("Back to Library") {
                viewModel.selectedQuiz = nil
            }
            .buttonStyle(.primary)
        }
        .padding()
        .foregroundColor(.white)
    }
}

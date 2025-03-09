//
//  DrillSummaryView.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 17/02/25.
//

import SwiftUI

extension DrillLibraryView {
    /// A view that displays the results and achievements after completing a drill.
    /// Shows performance metrics and any badges earned.
    struct DrillSummaryView: View {
        /// The accuracy score achieved in the drill (0.0-1.0).
        let accuracy: Double
        
        /// The total time taken to complete the drill in seconds.
        let timeTaken: Int
        
        /// Environment variable for dismissing the view.
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack(spacing: 24) {
                Text("Drill Complete! 🎉")
                    .font(.title.bold())
                
                VStack(spacing: 16) {
                    Text("Time Taken: \(timeTaken)s")
                    Text("Accuracy: \(Int(accuracy * 100))%")
                }
                .font(.title3)
                
                Text("Drilliant Badge Earned! 🏅")
                    .font(.headline)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Button("Back to Library") {
                    dismiss()
                }
                .buttonStyle(.primary)
            }
            .padding()
        }
    }
}

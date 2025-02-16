//
//  DrillSummaryView.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 17/02/25.
//

import SwiftUI

extension DrillLibraryView {
    struct DrillSummaryView: View {
        let accuracy: Double
        let timeTaken: Int
        
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
            }
            .padding()
        }
    }
}

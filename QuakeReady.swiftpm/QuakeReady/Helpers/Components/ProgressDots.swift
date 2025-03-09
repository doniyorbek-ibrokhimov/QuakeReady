//
//  ProgressDots.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 17/02/25.
//

import SwiftUI

/// A view that displays progress through a sequence using a row of dots.
/// Filled dots represent completed steps, while unfilled dots represent remaining steps.
struct ProgressDots: View {
    /// The total number of steps in the sequence.
    let totalSteps: Int
    
    /// The current step number (1-based index).
    let currentStep: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                Circle()
                    .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 12, height: 12)
            }
        }
    }
}

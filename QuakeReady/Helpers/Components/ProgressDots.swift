//
//  ProgressDots.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 17/02/25.
//

import SwiftUI

struct ProgressDots: View {
    let totalSteps: Int
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

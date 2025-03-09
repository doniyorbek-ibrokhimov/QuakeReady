//
//  ActionButton.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A customized button that adapts its text based on the current step in a drill.
/// Used for navigating through drill steps and completing the drill.
struct ActionButton: View {
    /// The current step number in the drill (1-3).
    let currentStep: Int
    
    /// Action to perform when the button is tapped.
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(currentStep < 3 ? "Next Step" : "Complete Drill")
        }
        .buttonStyle(.primary)
    }
}

//
//  ActionButton.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

struct ActionButton: View {
    let currentStep: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(currentStep < 3 ? "Next Step" : "Complete Drill")
        }
        .buttonStyle(.primary)
    }
}

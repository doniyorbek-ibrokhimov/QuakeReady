//
//  QuickActionButton.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A customizable button view for primary actions on the home screen.
/// Displays an icon and title with a colored background and scaling animation on tap.
struct QuickActionButton: View {
    /// The display title for the button.
    let title: String
    
    /// SF Symbol name for the button's icon.
    let icon: String
    
    /// The accent color for the button's background and text.
    let color: Color
    
    /// Closure to execute when the button is tapped.
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.subheadline.bold())
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.2))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
        }
        .foregroundColor(color)
        .buttonStyle(ScaleButtonStyle())
    }
}

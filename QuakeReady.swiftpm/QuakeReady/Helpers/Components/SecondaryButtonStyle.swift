//
//  SecondaryButtonStyle.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A custom button style for secondary actions throughout the app.
/// Provides a consistent appearance with gray background, white text, and interactive animations.
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

/// Extension providing a convenient static method for creating secondary button styles.
extension ButtonStyle where Self == SecondaryButtonStyle {
    /// Creates a secondary button style with default settings.
    static var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle()
    }
}

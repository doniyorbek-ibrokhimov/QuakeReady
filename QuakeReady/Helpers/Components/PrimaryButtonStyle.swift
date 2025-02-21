//
//  PrimaryButtonStyle.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A custom button style for primary actions throughout the app.
/// Provides a consistent appearance with blue background, white text, and interactive animations.
struct PrimaryButtonStyle: ButtonStyle {
    /// Controls whether the button is in a disabled state.
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .opacity(isDisabled ? 0.5 : 1.0)
            .disabled(isDisabled)
            .allowsHitTesting(!isDisabled)
    }
}

/// Extension providing convenient static methods for creating primary button styles.
extension ButtonStyle where Self == PrimaryButtonStyle {
    /// Creates a primary button style with default settings (enabled).
    static var primary: PrimaryButtonStyle {
        primary()
    }
    
    /// Creates a primary button style with optional disabled state.
    /// - Parameter isDisabled: Whether the button should be disabled
    /// - Returns: A configured primary button style
    static func primary(isDisabled: Bool = false) -> PrimaryButtonStyle {
        PrimaryButtonStyle(isDisabled: isDisabled)
    }
}

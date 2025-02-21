//
//  ScaleButtonStyle.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A custom button style that adds a subtle scale animation when pressed.
/// Provides tactile feedback through a slight enlargement of the button content.
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

/// Extension providing a convenient static method for creating scale button styles.
extension ButtonStyle where Self == ScaleButtonStyle {
    /// Creates a scale button style with default settings.
    static var scale: ScaleButtonStyle {
        ScaleButtonStyle()
    }
}

//
//  PrimaryButtonStyle.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
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

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        primary()
    }
    
    static func primary(isDisabled: Bool = false) -> PrimaryButtonStyle {
        PrimaryButtonStyle(isDisabled: isDisabled)
    }
}

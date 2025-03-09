//
//  OnboardingPage.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A model representing a single page in the onboarding flow.
struct OnboardingPage {
    /// The title displayed at the top of the page.
    let title: String
    
    /// A detailed description of the feature being introduced.
    let description: String
    
    /// SF Symbol name for the page's icon.
    let icon: String
    
    /// The accent color for the page's icon.
    let color: Color
} 

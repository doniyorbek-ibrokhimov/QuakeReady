//
//  RiskSection.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A section view that displays earthquake risk information for multiple countries.
/// Shows a header with title and icon, followed by a horizontal scrollable list of country cards.
struct RiskSection: View {
    /// The title of the risk section (e.g., "Global Earthquake Risks").
    let title: String
    
    /// SF Symbol name for the section's icon.
    let icon: String
    
    /// Array of countries to display in the section.
    let countries: [Country]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            Label(title, systemImage: icon)
                .font(.title2.bold())
                .padding(.horizontal)
            
            // Scrollable country cards
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 16) {
                    ForEach(countries) { country in
                        CountryCard(country: country)
                            .frame(width: 200)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

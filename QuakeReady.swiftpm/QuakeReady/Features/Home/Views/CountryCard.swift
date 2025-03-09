//
//  CountryCard.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

/// A card view that displays earthquake risk information for a specific country.
/// Shows the country's flag, name, earthquake frequency, magnitude, and yearly occurrence.
struct CountryCard: View {
    /// The country model containing risk assessment data.
    let country: Country
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Country identification header
            HStack {
                Text(country.flag)
                Text(country.name)
                    .font(.headline)
            }
            
            // Risk frequency indicator
            Text("Frequency: \(country.frequency)")
                .font(.body)
                .foregroundColor(country.frequency == "High" ? .red : .orange)
                .fontWeight(.bold)
            
            // Earthquake statistics
            Group {
                Text("Strongest: M\(country.magnitude, specifier: "%.1f")")
                Text("\(country.numberOfEarthquakes) earthquakes/year")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray5))
        .cornerRadius(12)
    }
}

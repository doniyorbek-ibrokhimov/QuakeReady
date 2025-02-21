//
//  CountryCard.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

struct CountryCard: View {
    let country: Country
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(country.flag)
                Text(country.name)
                    .font(.headline)
            }
            
            Text("Frequency: \(country.frequency)")
                .font(.body)
                .foregroundColor(country.frequency == "High" ? .red : .orange)
                .fontWeight(.bold)
            
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

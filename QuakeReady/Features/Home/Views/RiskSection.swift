//
//  RiskSection.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI

struct RiskSection: View {
    let title: String
    let icon: String
    let countries: [Country]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: icon)
                .font(.title2.bold())
                .padding(.horizontal)
            
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

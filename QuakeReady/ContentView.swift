//
//  ContentView.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 16/02/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // Mock data for global risks
    private let countries: [Country] = [
        Country(id: UUID(), name: "USA", flag: "🇺🇸", frequency: "Medium", damages: "$70B", injuries: "12,000"),
        Country(id: UUID(), name: "Japan", flag: "🇯🇵", frequency: "High", damages: "$100B", injuries: "15,000"),
        Country(id: UUID(), name: "Chile", flag: "🇨🇱", frequency: "High", damages: "$30B", injuries: "8,000"),
        Country(id: UUID(), name: "Indonesia", flag: "🇮🇩", frequency: "High", damages: "$40B", injuries: "10,000")
    ]
    
    // Mock data for nearby risks
    private let nearbyCountries: [Country] = [
        Country(id: UUID(), name: "South Korea", flag: "🇰🇷", frequency: "Low", damages: "$20B", injuries: "5,000"),
        Country(id: UUID(), name: "Taiwan", flag: "🇹🇼", frequency: "High", damages: "$45B", injuries: "9,000"),
        Country(id: UUID(), name: "Philippines", flag: "🇵🇭", frequency: "High", damages: "$25B", injuries: "7,000"),
        Country(id: UUID(), name: "Vietnam", flag: "🇻🇳", frequency: "Medium", damages: "$15B", injuries: "4,000")
    ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            homeView
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            // Drill Tab
            DrillLibraryView()
                .tabItem {
                    Label("Drill", systemImage: "figure.run")
                }
                .tag(1)
            
            // Quiz Tab
            QuizView()
                .tabItem {
                    Label("Quiz", systemImage: "questionmark.circle.fill")
                }
                .tag(2)
            
            // Badge Gallery Tab
            BadgeGalleryView()
                .tabItem {
                    Label("Badges", systemImage: "medal.fill")
                }
                .tag(3)
        }
    }
    
    private var homeView: some View {
        VStack(spacing: 24) {
            // Global Risks Section
            VStack(alignment: .leading, spacing: 16) {
                Label("Global Earthquake Risks", systemImage: "globe")
                    .font(.title2.bold())
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(countries) { country in
                            CountryCard(country: country)
                                .frame(width: 200)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("\(country.name) earthquake risk data")
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Nearby Risks Section
            VStack(alignment: .leading, spacing: 16) {
                Label("Nearby Earthquake Risks", systemImage: "location.circle.fill")
                    .font(.title2.bold())
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: [
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(nearbyCountries) { country in
                            CountryCard(country: country)
                                .frame(width: 200)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("\(country.name) earthquake risk data")
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()
        }
        .padding(.vertical, 24)
        .foregroundColor(.white)
    }
}

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
                Text("Damages: \(country.damages)")
                Text("Injuries: \(country.injuries)")
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

// FIXME: move to a separate file
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct Country: Identifiable {
    let id: UUID
    let name: String
    let flag: String
    let frequency: String
    let damages: String
    let injuries: String
}

#Preview {
    ContentView()
}

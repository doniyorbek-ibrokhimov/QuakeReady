//
//  HomeView.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 16/02/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    
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
            mainView
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
            QuizLibraryView()
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
    
    private var mainView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Quick Actions Section
                quickActionsSection
                
                // Progress Overview
                progressSection
                
                // Risk Assessment Sections
                riskAssessmentSection
            }
            .padding(.vertical, 24)
        }
        .background(Color.black)
        .foregroundColor(.white)
    }
    
    private var quickActionsSection: some View {
        VStack(spacing: 16) {
            Text("Quick Actions")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                QuickActionButton(
                    title: "Start Drill",
                    icon: "figure.run",
                    color: .blue
                ) {
                    selectedTab = 1
                }
                
                QuickActionButton(
                    title: "Take Quiz",
                    icon: "questionmark.circle.fill",
                    color: .purple
                ) {
                    selectedTab = 2
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var progressSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your Progress")
                    .font(.title2.bold())
                Spacer()
                Button("View All") {
                    selectedTab = 3
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ProgressCard(
                        title: "Drills",
                        icon: "figure.run",
                        progress: 0.7,
                        detail: "7/10 Complete"
                    )
                    
                    ProgressCard(
                        title: "Quizzes",
                        icon: "brain",
                        progress: 0.4,
                        detail: "4/10 Complete"
                    )
                    
                    ProgressCard(
                        title: "Badges",
                        icon: "medal.fill",
                        progress: 0.3,
                        detail: "3/10 Earned"
                    )
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var riskAssessmentSection: some View {
        VStack(spacing: 24) {
            // Global Risks
            RiskSection(
                title: "Global Earthquake Risks",
                icon: "globe",
                countries: countries
            )
            
            // Nearby Risks
            RiskSection(
                title: "Nearby Earthquake Risks",
                icon: "location.circle.fill",
                countries: nearbyCountries
            )
        }
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

// FIXME: move to a separate file
struct Country: Identifiable {
    let id: UUID
    let name: String
    let flag: String
    let frequency: String
    let damages: String
    let injuries: String
}

// Supporting Views
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.subheadline.bold())
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.2))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
        }
        .foregroundColor(color)
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ProgressCard: View {
    let title: String
    let icon: String
    let progress: Double
    let detail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
            }
            
            ProgressView(value: progress)
                .tint(.blue)
            
            Text(detail)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 160)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

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

#Preview {
    HomeView()
}

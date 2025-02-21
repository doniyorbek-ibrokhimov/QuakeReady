//
//  HomeView.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 16/02/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel: ViewModel
    private let modelContext: ModelContext

    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: ViewModel(modelContext: modelContext))
        self.modelContext = modelContext
    }
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            mainView
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            DrillLibraryView(modelContext: modelContext)
                .tabItem {
                    Label("Drill", systemImage: "figure.run")
                }
                .tag(1)
            
            QuizLibraryView(modelContext: modelContext)
                .tabItem {
                    Label("Quiz", systemImage: "questionmark.circle.fill")
                }
                .tag(2)
            
            BadgeGalleryView()
                .tabItem {
                    Label("Badges", systemImage: "medal.fill")
                }
                .tag(3)
        }
        .environmentObject(viewModel.badgeGalleryViewModel)
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
                    viewModel.selectedTab = 1
                }
                
                QuickActionButton(
                    title: "Take Quiz",
                    icon: "questionmark.circle.fill",
                    color: .purple
                ) {
                    viewModel.selectedTab = 2
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
                    viewModel.selectedTab = 3
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    let (drillProgress, drillDetail) = viewModel.drillProgress
                    let (quizProgress, quizDetail) = viewModel.quizProgress
                    let (badgeProgress, badgeDetail) = viewModel.badgeProgress
                    
                    ProgressCard(
                        title: "Drills",
                        icon: "figure.run",
                        progress: drillProgress,
                        detail: drillDetail
                    )
                    
                    ProgressCard(
                        title: "Quizzes",
                        icon: "brain",
                        progress: quizProgress,
                        detail: quizDetail
                    )
                    
                    ProgressCard(
                        title: "Badges",
                        icon: "medal.fill",
                        progress: badgeProgress,
                        detail: badgeDetail
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
                countries: viewModel.globalRisks
            )
            
            // Nearby Risks
            RiskSection(
                title: "Nearby Earthquake Risks",
                icon: "location.circle.fill",
                countries: viewModel.nearbyRisks
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

// TODO: move to a separate file
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// TODO: move to a separate file
struct Country: Identifiable {
    let id: UUID
    let name: String
    let flag: String
    let frequency: String
    let magnitude: Double
    let numberOfEarthquakes: Int
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

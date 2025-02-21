//
//  HomeView.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 16/02/25.
//

import SwiftUI
import SwiftData

/// The main home screen of the QuakeReady app.
/// Provides quick access to drills, quizzes, and displays user progress and risk assessments.
struct HomeView: View {
    /// View model managing the home screen state and business logic.
    @StateObject private var viewModel: ViewModel
    
    /// SwiftData context for persistence.
    private let modelContext: ModelContext
    
    /// Initializes a new home view.
    /// - Parameter modelContext: SwiftData context for persistence
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
    
    /// The main content view of the home screen.
    /// Displays quick actions, progress overview, and risk assessment sections.
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
    
    /// Section displaying quick action buttons for starting drills and quizzes.
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
    
    /// Section showing progress cards for drills, quizzes, and badges.
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
    
    /// Section displaying global and nearby earthquake risk assessments.
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

import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Welcome to QuakeReady",
            description: "Your personal earthquake safety companion. Learn, practice, and stay prepared for any seismic event.",
            icon: "shield.fill",
            color: .blue
        ),
        OnboardingPage(
            title: "Interactive Drills",
            description: "Practice life-saving techniques through our interactive earthquake drills. Master the Drop, Cover, and Hold protocol.",
            icon: "figure.run",
            color: .orange
        ),
        OnboardingPage(
            title: "Safety Quizzes",
            description: "Test your knowledge with our comprehensive safety quizzes. Learn crucial safety protocols and best practices.",
            icon: "questionmark.circle.fill",
            color: .purple
        ),
        OnboardingPage(
            title: "Earn Badges",
            description: "Track your progress and earn badges as you become a safety expert. Challenge yourself to unlock all achievements.",
            icon: "medal.fill",
            color: .yellow
        )
    ]
    
    init(hasCompletedOnboarding: Binding<Bool>) {
        self._hasCompletedOnboarding = hasCompletedOnboarding
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.blue)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.gray.opacity(0.3))
    }
    
    var body: some View {
        VStack(spacing: 40) {
            // Page Content
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack(spacing: 24) {
                        Image(systemName: pages[index].icon)
                            .font(.system(size: 80))
                            .foregroundColor(pages[index].color)
                            .symbolEffect(.bounce, options: .repeating)
                        
                        Text(pages[index].title)
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                        
                        Text(pages[index].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 32)
                    }
                    .tag(index)
                    .padding(.top, 60)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 16) {
                if currentPage < pages.count - 1 {
                    Button("Next") {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                    .buttonStyle(.primary)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    
                    Button("Skip") {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }
                    .foregroundColor(.blue)
                    .font(.headline)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    Button("Get Started") {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }
                    .buttonStyle(.primary)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .foregroundColor(.white)
        .animation(.spring, value: currentPage)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let color: Color
} 

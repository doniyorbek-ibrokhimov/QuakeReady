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
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
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
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Page Indicator
                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.spring, value: currentPage)
                    }
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Skip")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .foregroundColor(.white)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let color: Color
} 
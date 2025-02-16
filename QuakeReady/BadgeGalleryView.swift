import SwiftUI

struct BadgeGalleryView: View {
    @State private var showingToast = false
    @State private var toastMessage = ""
    
    private let badges = [
        Badge(
            title: "Quick Learner",
            icon: "bolt.fill",
            criteria: "Finish 1 Quiz",
            earned: true,
            earnedDate: "March 5, 2024"
        ),
        Badge(
            title: "Drill Master",
            icon: "figure.run",
            criteria: "Complete 3 Drills",
            earned: true,
            earnedDate: "March 6, 2024"
        ),
        Badge(
            title: "Safety Scholar",
            icon: "book.closed.fill",
            criteria: "Score 100% on 5 Quizzes",
            earned: false,
            earnedDate: nil
        ),
        Badge(
            title: "Global Guardian",
            icon: "globe",
            criteria: "View 10 Countries",
            earned: false,
            earnedDate: nil
        )
    ]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Text("Your Achievements: \(earnedBadgesCount)/\(badges.count) Badges Unlocked")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Badge Grid
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(badges) { badge in
                        BadgeCard(badge: badge)
                            .opacity(badge.earned ? 1 : 0.4)
                            .onTapGesture {
                                handleBadgeTap(badge)
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.black)
        .foregroundColor(.white)
        .overlay(
            ToastView(message: toastMessage, isShowing: $showingToast)
        )
    }
    
    private var earnedBadgesCount: Int {
        badges.filter { $0.earned }.count
    }
    
    private func handleBadgeTap(_ badge: Badge) {
        if badge.earned {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } else {
            toastMessage = "Locked: \(badge.criteria)"
            showingToast = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showingToast = false
            }
        }
    }
}

struct Badge: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let criteria: String
    let earned: Bool
    let earnedDate: String?
}

struct BadgeCard: View {
    let badge: Badge
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: badge.icon)
                .font(.system(size: 32))
                .foregroundColor(badge.earned ? .yellow : .gray)
            
            Text(badge.title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            if badge.earned {
                Text("Earned: \(badge.earnedDate!)")
                    .font(.caption2)
                    .foregroundColor(.gray)
            } else {
                Text(badge.criteria)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        if isShowing {
            VStack {
                Spacer()
                Text(message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                    .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    BadgeGalleryView()
        .preferredColorScheme(.dark)
}

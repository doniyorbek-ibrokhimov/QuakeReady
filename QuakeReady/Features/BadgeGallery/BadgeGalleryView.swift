import SwiftUI

enum BadgeStatus: Equatable {
    case earned(date: Date)
    case locked(criteria: String)
    
    var isEarned: Bool {
        if case .earned = self { return true }
        return false
    }
}

struct Badge: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let status: BadgeStatus
    let description: String
}

struct BadgeGalleryView: View {
    @State private var showingToast = false
    @State private var toastMessage = ""
    @State private var selectedFilter: BadgeFilter = .all
    @State private var selectedBadge: Badge?
    @State private var showingBadgeDetails = false
    
    enum BadgeFilter {
        case all, earned, locked
    }
    
    private let badges = [
        Badge(
            title: "Quick Learner",
            icon: "bolt.fill",
            status: .earned(date: Date()),
            description: "Awarded for completing your first quiz"
        ),
        Badge(
            title: "Drill Master",
            icon: "figure.run",
            status: .earned(date: Date().addingTimeInterval(-86400)),
            description: "Completed 3 earthquake drills"
        ),
        Badge(
            title: "Safety Scholar",
            icon: "book.closed.fill",
            status: .locked(criteria: "Score 100% on 5 Quizzes"),
            description: "Become a safety expert"
        ),
        Badge(
            title: "Global Guardian",
            icon: "globe",
            status: .locked(criteria: "View 10 Countries"),
            description: "Explore earthquake risks worldwide"
        )
    ]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    headerSection
                    
                    // Filter Tabs
                    filterTabs
                    
                    // Badge Grid
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(filteredBadges) { badge in
                            BadgeCard(badge: badge)
                                .onTapGesture {
                                    handleBadgeTap(badge)
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .foregroundColor(.white)
        .sheet(isPresented: $showingBadgeDetails) {
            if let badge = selectedBadge {
                BadgeDetailView(badge: badge)
            }
        }
        .overlay(
            ToastView(message: toastMessage, isShowing: $showingToast)
        )
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Your Achievements")
                .font(.title.bold())
            
            ProgressView(value: Double(earnedBadgesCount), total: Double(badges.count)) {
                Text("\(earnedBadgesCount)/\(badges.count) Badges Unlocked")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .tint(.blue)
            .padding(.horizontal)
        }
    }
    
    private var filterTabs: some View {
        HStack {
            ForEach([BadgeFilter.all, .earned, .locked], id: \.self) { filter in
                Button(action: { selectedFilter = filter }) {
                    Text(filter.title)
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(selectedFilter == filter ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(20)
                }
            }
        }
    }
    
    private var filteredBadges: [Badge] {
        switch selectedFilter {
        case .all: return badges
        case .earned: return badges.filter { $0.status.isEarned }
        case .locked: return badges.filter { !$0.status.isEarned }
        }
    }
    
    private var earnedBadgesCount: Int {
        badges.filter { $0.status.isEarned }.count
    }
    
    private func handleBadgeTap(_ badge: Badge) {
        selectedBadge = badge
        
        switch badge.status {
        case .earned(let date):
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            toastMessage = "Earned on \(formatter.string(from: date))"
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            showingBadgeDetails = true
            
        case .locked(let criteria):
            toastMessage = "Locked: \(criteria)"
            showingToast = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showingToast = false
            }
        }
    }
}

extension BadgeGalleryView.BadgeFilter {
    var title: String {
        switch self {
        case .all: return "All"
        case .earned: return "Earned"
        case .locked: return "Locked"
        }
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

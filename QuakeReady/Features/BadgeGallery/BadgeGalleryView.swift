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
    var status: BadgeStatus
    let description: String
}

struct BadgeGalleryView: View {
    @StateObject private var viewModel = ViewModel()
    
    enum BadgeFilter {
        case all, earned, locked
    }
    
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
                        ForEach(viewModel.filteredBadges) { badge in
                            BadgeCard(badge: badge)
                                .onTapGesture {
                                    viewModel.handleBadgeTap(badge)
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .foregroundColor(.white)
        .sheet(isPresented: $viewModel.showingBadgeDetails) {
            if let badge = viewModel.selectedBadge {
                BadgeDetailView(badge: badge)
            }
        }
        .overlay(
            ToastView(message: viewModel.toastMessage, isShowing: $viewModel.showingToast)
        )
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Your Achievements")
                .font(.title.bold())
            
            ProgressView(value: Double(viewModel.earnedBadgesCount), total: Double(viewModel.badges.count)) {
                Text("\(viewModel.earnedBadgesCount)/\(viewModel.badges.count) Badges Unlocked")
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
                Button(action: { viewModel.selectedFilter = filter }) {
                    Text(filter.title)
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(viewModel.selectedFilter == filter ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(20)
                }
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

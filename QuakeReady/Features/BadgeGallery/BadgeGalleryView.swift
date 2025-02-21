import SwiftUI
import SwiftData

struct BadgeGalleryView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @Namespace private var badgeNamespace

    enum BadgeFilter {
        case all, earned, locked
        
        var title: String {
            switch self {
            case .all: return "All"
            case .earned: return "Earned"
            case .locked: return "Locked"
            }
        }
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
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
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal)
                .animation(.spring(duration: 0.3), value: viewModel.selectedFilter)
            }
            .padding(.vertical)
        }
        .foregroundColor(.white)
        .sheet(item: $viewModel.selectedBadge) { badge in
            BadgeDetailView(badge: badge)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Your Achievements")
                .font(.title.bold())
            
            ProgressView(value: Double(viewModel.earnedBadgesCount), total: Double(viewModel.totalBadgesCount)) {
                Text("\(viewModel.earnedBadgesCount)/\(viewModel.totalBadgesCount) Badges Unlocked")
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
                Button(action: { 
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.selectedFilter = filter
                    }
                }) {
                    Text(filter.title)
                        .font(.subheadline)
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size * 0.2
                        }
                        .padding(.vertical, 8)
                        .background {
                            if viewModel.selectedFilter == filter {
                                Color.blue
                                    .matchedGeometryEffect(id: "badge", in: badgeNamespace)
                                    .clipShape(.capsule)
                            }
                        }
                }
            }
        }
    }
}

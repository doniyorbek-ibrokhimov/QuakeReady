//
//  BadgeGalleryView.swift
//  QuakeReady
//
//  Created by Doniyorbek Ibrokhimov on 22/02/25.
//

import SwiftUI
import SwiftData

/// A view that showcases the user's badge collection with filtering and progress tracking
///
/// Features:
/// - Progress tracking header
/// - Interactive filter tabs (All/Earned/Locked)
/// - Animated badge grid with tap interactions
struct BadgeGalleryView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @Namespace private var badgeNamespace
    
    /// Filter options for badge display
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
    
    /// Grid layout configuration
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header showing achievement progress
                headerSection
                
                // Interactive filter tabs
                filterTabs
                
                // Animated badge grid
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
    
    /// Header section showing total progress and title
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
    
    /// Interactive filter tabs with animation
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

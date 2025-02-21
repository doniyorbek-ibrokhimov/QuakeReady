import SwiftUI
import SwiftData

enum BadgeStatus: Equatable {
    case earned(date: Date)
    case locked(criteria: String)
    
    var isEarned: Bool {
        if case .earned = self { return true }
        return false
    }
}

enum BadgeType: String, CaseIterable {
    case quickLearner
    case drillBeginner
    case drillMaster 
    case safetyScholar
    case globalGuardian
    
    var title: String {
        switch self {
        case .quickLearner: return "Quick Learner"
        case .drillBeginner: return "Drill Beginner"
        case .drillMaster: return "Drill Master"
        case .safetyScholar: return "Safety Scholar"
        case .globalGuardian: return "Global Guardian"
        }
    }
    
    var icon: String {
        switch self {
        case .quickLearner: return "bolt.fill"
        case .drillBeginner: return "figure.walk"
        case .drillMaster: return "figure.run"
        case .safetyScholar: return "book.closed.fill"
        case .globalGuardian: return "globe"
        }
    }
    
    var description: String {
        switch self {
        case .quickLearner: return "Awarded for completing your first quiz"
        case .drillBeginner: return "Completed your first earthquake drill"
        case .drillMaster: return "Completed 3 earthquake drills"
        case .safetyScholar: return "Become a safety expert"
        case .globalGuardian: return "Explore earthquake risks worldwide"
        }
    }
    
    var criteria: String {
        switch self {
        case .quickLearner: return "Score 100% on 5 Quizzes"
        case .drillBeginner: return "Complete your first drill"
        case .drillMaster: return "Complete 3 earthquake drills"
        case .safetyScholar: return "Score 100% on all quizzes"
        case .globalGuardian: return "View 10 Countries"
        }
    }
}

struct Badge: Identifiable {
    let id = UUID()
    let type: BadgeType
    var status: BadgeStatus
    
    var title: String { type.title }
    var icon: String { type.icon }
    var description: String { type.description }
}

struct BadgeGalleryView: View {
    @EnvironmentObject private var viewModel: ViewModel
    @Namespace private var badgeNamespace

    enum BadgeFilter {
        case all, earned, locked
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

extension BadgeGalleryView.BadgeFilter {
    var title: String {
        switch self {
        case .all: return "All"
        case .earned: return "Earned"
        case .locked: return "Locked"
        }
    }
}

class BadgeProgress: ObservableObject {
    @Published private var earnedBadges: [BadgeType: Date] = [:]
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadPersistedBadges()
    }
    
    var earnedBadgesCount: Int {
        earnedBadges.count
    }
    
    var totalBadgesCount: Int {
        BadgeType.allCases.count
    }
    
    private func loadPersistedBadges() {
        do {
            let descriptor = FetchDescriptor<BadgeAchievement>()
            let achievements = try modelContext.fetch(descriptor)
            
            for achievement in achievements {
                if let badgeType = BadgeType(rawValue: achievement.type) {
                    earnedBadges[badgeType] = achievement.earnedDate
                }
            }
        } catch {
            print("Failed to fetch badges: \(error)")
        }
    }
    
    func isEarned(_ type: BadgeType) -> Bool {
        earnedBadges[type] != nil
    }
    
    func earnBadge(_ type: BadgeType) {
        let date = Date()
        earnedBadges[type] = date
        
        // Persist to SwiftData
        let achievement = BadgeAchievement(type: type.rawValue, earnedDate: date)
        modelContext.insert(achievement)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save badge: \(error)")
        }
    }
    
    func getBadgeStatus(_ type: BadgeType) -> BadgeStatus {
        if let date = earnedBadges[type] {
            return .earned(date: date)
        }
        return .locked(criteria: type.criteria)
    }
}

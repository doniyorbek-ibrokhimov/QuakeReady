import SwiftUI
import SwiftData

extension HomeView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var selectedTab = 0
        private let modelContext: ModelContext
        private let drillLibraryViewModel: DrillLibraryView.ViewModel
        private let quizLibraryViewModel: QuizLibraryView.ViewModel
        let badgeGalleryViewModel: BadgeGalleryView.ViewModel
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            self.drillLibraryViewModel = DrillLibraryView.ViewModel(modelContext: modelContext)
            self.quizLibraryViewModel = QuizLibraryView.ViewModel(modelContext: modelContext)
            self.badgeGalleryViewModel = BadgeGalleryView.ViewModel(modelContext: modelContext)
        }
        
        // Progress calculations
        var drillProgress: (Double, String) {
            let completed = drillLibraryViewModel.recentDrills.count
            let total = drillLibraryViewModel.drills.count
            return (Double(completed) / Double(total), "\(completed)/\(total) Complete")
        }
        
        var quizProgress: (Double, String) {
            let completed = quizLibraryViewModel.quizzes.filter { $0.completion > 0 }.count
            let total = quizLibraryViewModel.quizzes.count
            return (Double(completed) / Double(total), "\(completed)/\(total) Complete")
        }
        
        var badgeProgress: (Double, String) {
            let earned = badgeGalleryViewModel.badgeProgress.earnedBadgesCount
            let total = badgeGalleryViewModel.badgeProgress.totalBadgesCount
            return (Double(earned) / Double(total), "\(earned)/\(total) Earned")
        }
        
        // Mock data for risk assessment
        let globalRisks: [Country] = [
            Country(id: UUID(), name: "USA", flag: "🇺🇸", frequency: "Medium", damages: "$70B", injuries: "12,000"),
            Country(id: UUID(), name: "Japan", flag: "🇯🇵", frequency: "High", damages: "$100B", injuries: "15,000"),
            Country(id: UUID(), name: "Chile", flag: "🇨🇱", frequency: "High", damages: "$30B", injuries: "8,000"),
            Country(id: UUID(), name: "Indonesia", flag: "🇮🇩", frequency: "High", damages: "$40B", injuries: "10,000")
        ]
        
        let nearbyRisks: [Country] = [
            Country(id: UUID(), name: "South Korea", flag: "🇰🇷", frequency: "Low", damages: "$20B", injuries: "5,000"),
            Country(id: UUID(), name: "Taiwan", flag: "🇹🇼", frequency: "High", damages: "$45B", injuries: "9,000"),
            Country(id: UUID(), name: "Philippines", flag: "🇵🇭", frequency: "High", damages: "$25B", injuries: "7,000"),
            Country(id: UUID(), name: "Vietnam", flag: "🇻🇳", frequency: "Medium", damages: "$15B", injuries: "4,000")
        ]
    }
} 

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
            Country(id: UUID(), name: "USA", flag: "🇺🇸", frequency: "Medium", magnitude: 7.1, numberOfEarthquakes: 120),
            Country(id: UUID(), name: "Japan", flag: "🇯🇵", frequency: "High", magnitude: 8.2, numberOfEarthquakes: 480),
            Country(id: UUID(), name: "Chile", flag: "🇨🇱", frequency: "High", magnitude: 7.8, numberOfEarthquakes: 250),
            Country(id: UUID(), name: "Indonesia", flag: "🇮🇩", frequency: "High", magnitude: 7.9, numberOfEarthquakes: 350)
        ]
        
        let nearbyRisks: [Country] = [
            Country(id: UUID(), name: "South Korea", flag: "🇰🇷", frequency: "Low", magnitude: 5.4, numberOfEarthquakes: 30),
            Country(id: UUID(), name: "Taiwan", flag: "🇹🇼", frequency: "High", magnitude: 7.6, numberOfEarthquakes: 180),
            Country(id: UUID(), name: "Philippines", flag: "🇵🇭", frequency: "High", magnitude: 7.2, numberOfEarthquakes: 200),
            Country(id: UUID(), name: "Vietnam", flag: "🇻🇳", frequency: "Medium", magnitude: 6.8, numberOfEarthquakes: 85)
        ]
    }
} 

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
        
        let globalRisks: [Country] = [
            Country(id: UUID(), name: "Mexico", flag: "🇲🇽", frequency: "High", magnitude: 6.4, numberOfEarthquakes: 1972),
            Country(id: UUID(), name: "Indonesia", flag: "🇮🇩", frequency: "High", magnitude: 6.4, numberOfEarthquakes: 1870),
            Country(id: UUID(), name: "Japan", flag: "🇯🇵", frequency: "High", magnitude: 7.5, numberOfEarthquakes: 1559),
            Country(id: UUID(), name: "Philippines", flag: "🇵🇭", frequency: "High", magnitude: 7.1, numberOfEarthquakes: 996)
        ]
        
        let nearbyRisks: [Country] = [
            Country(id: UUID(), name: "Mexico", flag: "🇲🇽", frequency: "High", magnitude: 6.4, numberOfEarthquakes: 1972),
            Country(id: UUID(), name: "Canada", flag: "🇨🇦", frequency: "Medium", magnitude: 5.7, numberOfEarthquakes: 63),
            Country(id: UUID(), name: "Guatemala", flag: "🇬🇹", frequency: "High", magnitude: 6.4, numberOfEarthquakes: 704),
            Country(id: UUID(), name: "El Salvador", flag: "🇸🇻", frequency: "High", magnitude: 6.2, numberOfEarthquakes: 366)
        ]
    }
} 

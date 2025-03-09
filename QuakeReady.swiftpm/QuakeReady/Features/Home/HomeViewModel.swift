import SwiftUI
import SwiftData

extension HomeView {
    /// View model managing the home screen's state and data.
    /// Coordinates between different feature view models and calculates progress metrics.
    @MainActor
    class ViewModel: ObservableObject {
        /// Currently selected tab in the main navigation.
        @Published var selectedTab = 0
        
        /// SwiftData context for persistence.
        private let modelContext: ModelContext
        
        /// View model for the drill library feature.
        private let drillLibraryViewModel: DrillLibraryView.ViewModel
        
        /// View model for the quiz library feature.
        private let quizLibraryViewModel: QuizLibraryView.ViewModel
        
        /// View model for the badge gallery feature.
        let badgeGalleryViewModel: BadgeGalleryView.ViewModel
        
        /// Initializes the home view model.
        /// - Parameter modelContext: SwiftData context for persistence
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            self.drillLibraryViewModel = DrillLibraryView.ViewModel(modelContext: modelContext)
            self.quizLibraryViewModel = QuizLibraryView.ViewModel(modelContext: modelContext)
            self.badgeGalleryViewModel = BadgeGalleryView.ViewModel(modelContext: modelContext)
        }
        
        /// Calculates the progress for drills.
        /// - Returns: A tuple containing:
        ///   - Double: Progress value (0.0-1.0)
        ///   - String: Formatted progress description
        var drillProgress: (Double, String) {
            let completed = drillLibraryViewModel.recentDrills.count
            let total = drillLibraryViewModel.drills.count
            return (Double(completed) / Double(total), "\(completed)/\(total) Complete")
        }
        
        /// Calculates the progress for quizzes.
        /// - Returns: A tuple containing:
        ///   - Double: Progress value (0.0-1.0)
        ///   - String: Formatted progress description
        var quizProgress: (Double, String) {
            let completed = quizLibraryViewModel.quizzes.filter { $0.completion > 0 }.count
            let total = quizLibraryViewModel.quizzes.count
            return (Double(completed) / Double(total), "\(completed)/\(total) Complete")
        }
        
        /// Calculates the progress for badges.
        /// - Returns: A tuple containing:
        ///   - Double: Progress value (0.0-1.0)
        ///   - String: Formatted progress description
        var badgeProgress: (Double, String) {
            let earned = badgeGalleryViewModel.badgeProgress.earnedBadgesCount
            let total = badgeGalleryViewModel.badgeProgress.totalBadgesCount
            return (Double(earned) / Double(total), "\(earned)/\(total) Earned")
        }
        
        /// List of countries with high earthquake risk globally.
        let globalRisks: [Country] = [
            Country(id: UUID(), name: "Mexico", flag: "🇲🇽", frequency: "High", magnitude: 6.4, numberOfEarthquakes: 1972),
            Country(id: UUID(), name: "Indonesia", flag: "🇮🇩", frequency: "High", magnitude: 6.4, numberOfEarthquakes: 1870),
            Country(id: UUID(), name: "Japan", flag: "🇯🇵", frequency: "High", magnitude: 7.5, numberOfEarthquakes: 1559),
            Country(id: UUID(), name: "Philippines", flag: "🇵🇭", frequency: "High", magnitude: 7.1, numberOfEarthquakes: 996)
        ]
        
        /// List of countries with high earthquake risk near the user's location(in development).
        let nearbyRisks: [Country] = [
            Country(id: UUID(), name: "Mexico", flag: "🇲🇽", frequency: "High", magnitude: 6.4, numberOfEarthquakes: 1972),
            Country(id: UUID(), name: "Canada", flag: "🇨🇦", frequency: "Medium", magnitude: 5.7, numberOfEarthquakes: 63),
            Country(id: UUID(), name: "Guatemala", flag: "🇬🇹", frequency: "High", magnitude: 6.4, numberOfEarthquakes: 704),
            Country(id: UUID(), name: "El Salvador", flag: "🇸🇻", frequency: "High", magnitude: 6.2, numberOfEarthquakes: 366)
        ]
    }
} 

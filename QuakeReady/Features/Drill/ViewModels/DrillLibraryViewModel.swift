import SwiftUI

extension DrillLibraryView {
    class ViewModel: ObservableObject {
        @Published var selectedDrill: Drill?
        
        let drills = [
            Drill(
                type: .basic,
                title: "Basic Drop-Cover-Hold",
                icon: "⚠️",
                duration: 30,
                difficulty: .beginner,
                steps: ["Drop to the ground", "Cover your head", "Hold on"],
                isNew: false
            ),
            Drill(
                type: .elevator,
                title: "Elevator Safety Protocol",
                icon: "🛗",
                duration: 45,
                difficulty: .intermediate,
                steps: ["Press all floor buttons", "Brace against wall", "Exit quickly when possible"],
                isNew: true
            ),
            Drill(
                type: .crowd,
                title: "Crowded Space Protocol",
                icon: "👥",
                duration: 60,
                difficulty: .advanced,
                steps: ["Stay calm", "Move away from crowds", "Find stable shelter"],
                isNew: true
            )
        ]
        
        var recentDrills: [Drill] {
            drills.filter { $0.lastCompleted != nil }
        }
    }
}

import SwiftUI

struct DrillLibraryView: View {
    @State private var selectedDrill: Drill?
    @State private var showingDrillSimulator = false
    
    private let drills = [
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
    
    private var recentDrills: [Drill] {
        drills.filter({ $0.lastCompleted != nil })
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Practice Drills")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(drills) { drill in
                        DrillCard(drill: drill)
                            .onTapGesture {
                                selectedDrill = drill
                                showingDrillSimulator = true
                            }
                    }
                }
                .padding(.horizontal)
                
                if !recentDrills.isEmpty {
                    RecentDrillsSection(drills: recentDrills)
                }
            }
        }
        .padding(.vertical)
        .sheet(isPresented: $showingDrillSimulator) {
            if let drill = selectedDrill {
                DrillSimulatorView(drill: drill)
            }
        }
    }
} 

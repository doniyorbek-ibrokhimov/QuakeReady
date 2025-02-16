import SwiftUI

enum DrillType: String, CaseIterable {
    case basic = "Basic Drop-Cover-Hold"
    case elevator = "Elevator Safety Protocol"
    case crowd = "Crowded Space Protocol"
}

struct Drill: Identifiable {
    let id = UUID()
    let type: DrillType
    let title: String
    let icon: String
    let duration: Int
    let difficulty: Difficulty
    let steps: [String]
    let isNew: Bool
    var lastCompleted: Date?
    
    enum Difficulty: String {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        
        var color: Color {
            switch self {
            case .beginner: return .blue
            case .intermediate: return .orange
            case .advanced: return .red
            }
        }
    }
}

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

struct DrillCard: View {
    let drill: Drill
    
    var body: some View {
        HStack(spacing: 16) {
            Text(drill.icon)
                .font(.title)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(drill.title)
                        .font(.headline)
                    if drill.isNew {
                        Text("NEW")
                            .font(.caption2.bold())
                            .foregroundColor(.green)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
                
                HStack {
                    Text("Duration: \(drill.duration)s")
                    Text("•")
                    Text(drill.difficulty.rawValue)
                        .foregroundColor(drill.difficulty.color)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

struct RecentDrillsSection: View {
    let drills: [Drill]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recently Completed")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(drills) { drill in
                HStack {
                    Text(drill.icon)
                    Text(drill.title)
                        .font(.subheadline)
                    Spacer()
                    if let date = drill.lastCompleted {
                        Text(date, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 32)
    }
} 

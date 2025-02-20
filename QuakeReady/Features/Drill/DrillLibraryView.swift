import SwiftUI

struct DrillLibraryView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            content
                .navigationDestination(item: $viewModel.selectedDrill) { drill in
                    DrillSimulatorView(drill: drill)
                }
        }
        .environmentObject(viewModel)
    }
    
    private var content: some View {
        VStack(spacing: 24) {
            Text("Practice Drills")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.drills) { drill in
                        DrillCard(drill: drill)
                            .onTapGesture {
                                viewModel.selectedDrill = drill
                            }
                    }
                }
                .padding(.horizontal)
                
                if !viewModel.recentDrills.isEmpty {
                    RecentDrillsSection(drills: viewModel.recentDrills)
                }
            }
        }
        .padding(.vertical)
    }
}

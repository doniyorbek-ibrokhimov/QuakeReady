import SwiftUI
import SwiftData

/// The main view for browsing and accessing earthquake safety drills.
/// Displays a list of available drills and recently completed drills.
struct DrillLibraryView: View {
    /// View model managing the drill library state and business logic.
    @StateObject private var viewModel: ViewModel
    
    /// View model for managing badge progress and achievements.
    @EnvironmentObject private var badgeViewModel: BadgeGalleryView.ViewModel
    
    /// Initializes a new drill library view.
    /// - Parameter modelContext: SwiftData context for persistence
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: ViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationDestination(item: $viewModel.selectedDrill) { drill in
                    DrillSimulatorView(
                        drill: drill,
                        badgeProgress: badgeViewModel.badgeProgress,
                        drillLibraryViewModel: viewModel
                    )
                    .navigationBarBackButtonHidden()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                viewModel.selectedDrill = nil
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Practice Drills")
                                }
                            }
                        }
                    }
                }
        }
        .environmentObject(viewModel)
    }
    
    /// The main content view displaying the drill library.
    /// Shows available drills and recently completed drills if any exist.
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

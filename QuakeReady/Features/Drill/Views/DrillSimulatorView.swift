import SwiftUI

extension DrillLibraryView {
    /// A view that guides users through completing an earthquake safety drill.
    /// Provides step-by-step instructions, timing, and progress tracking.
    struct DrillSimulatorView: View {
        /// View model managing the drill simulation state and logic.
        @StateObject private var viewModel: ViewModel
        
        /// Initializes a new drill simulator view.
        /// - Parameters:
        ///   - drill: The drill to simulate
        ///   - badgeProgress: Service for tracking badge achievements
        ///   - drillLibraryViewModel: Parent view model for updating completion status
        init(drill: Drill, badgeProgress: BadgeProgress, drillLibraryViewModel: DrillLibraryView.ViewModel) {
            _viewModel = StateObject(wrappedValue: ViewModel(
                drill: drill,
                badgeProgress: badgeProgress,
                drillLibraryViewModel: drillLibraryViewModel
            ))
        }
        
        var body: some View {
            NavigationStack {
                content
                    .animation(.easeInOut, value: viewModel.currentStep)
                    .navigationDestination(isPresented: $viewModel.showSummary) {
                        DrillSummaryView(accuracy: viewModel.drillAccuracy, 
                                       timeTaken: viewModel.totalTimeTaken)
                    }
                    .environmentObject(viewModel)
            }
        }
        
        /// The main content view containing the timer, instructions, and navigation controls.
        private var content: some View {
            VStack(spacing: 32) {
                // Time Remaining Meter
                TimerView(
                    timeRemaining: viewModel.drill.duration
                )
                .frame(width: 120, height: 120)
                
                // Step Instructions
                InstructionCard(
                    step: viewModel.currentStep,
                    text: viewModel.drill.steps[viewModel.currentStep - 1],
                    instructions: viewModel.drill.instructions
                )
                
                Spacer()
                
                // Navigation Controls
                HStack {
                    if viewModel.currentStep > 1 {
                        Button("Previous Step") {
                            viewModel.prevStep()
                        }
                        .buttonStyle(.secondary)
                    }
                    
                    ActionButton(
                        currentStep: viewModel.currentStep,
                        action: viewModel.nextStep
                    )
                }
            }
            .padding()
        }
    }
}



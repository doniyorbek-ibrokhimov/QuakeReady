import SwiftUI

extension DrillLibraryView {
    struct DrillSimulatorView: View {
        @StateObject private var viewModel: ViewModel
        
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
                    checklistItems: viewModel.drill.checklistItems
                )
                
                Spacer()
                
                // Action Button
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



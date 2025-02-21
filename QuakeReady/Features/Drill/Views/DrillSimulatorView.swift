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
            }
            .onAppear {
                viewModel.startSimulation()
            }
            .onChange(of: viewModel.timeRemaining) { _ in
                viewModel.updateIntensity()
            }
        }
        
        private var content: some View {
            ZStack {
                // Environment Layer
//                EnvironmentView(drill: viewModel.drill, intensity: viewModel.shakeIntensity)
//                    .opacity(viewModel.environmentOpacity)
                
                // Main Content
                VStack(spacing: 32) {
                    // Intensity Meter
                    IntensityMeter(value: viewModel.shakeIntensity)
                        .frame(width: 120, height: 120)
                    
                    // Interactive Character
//                    CharacterView(step: viewModel.currentStep)
//                        .frame(height: 200)
                    
                    // Step Instructions
                    InstructionCard(
                        step: viewModel.currentStep,
                        text: viewModel.drill.steps[viewModel.currentStep - 1],
                        timeRemaining: viewModel.timeRemaining
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
}



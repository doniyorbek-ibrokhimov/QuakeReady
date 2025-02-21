import SwiftUI
import SwiftData

/// A view that displays a collection of available safety quizzes.
/// Provides access to individual quizzes and tracks completion progress.
struct QuizLibraryView: View {
    /// View model managing the quiz library state and business logic.
    @StateObject private var viewModel: ViewModel
    
    /// View model for managing badge progress and achievements.
    @EnvironmentObject private var badgeViewModel: BadgeGalleryView.ViewModel
    
    /// Initializes a new quiz library view.
    /// - Parameter modelContext: SwiftData context for persistence
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: ViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationDestination(item: $viewModel.selectedQuiz) { quiz in
                    QuizView(
                        quiz: quiz,
                        badgeProgress: badgeViewModel.badgeProgress,
                        quizLibraryViewModel: viewModel
                    )
                    .navigationBarBackButtonHidden()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                viewModel.selectedQuiz = nil
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Safety Quizzes")
                                }
                            }
                        }
                    }
                }
        }
        .environmentObject(viewModel)
    }
    
    /// The main content view displaying the quiz library.
    /// Shows a scrollable list of quiz cards with completion status.
    private var content: some View {
        VStack(spacing: 24) {
            Text("Safety Quizzes")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.quizzes) { quiz in
                        QuizCard(quiz: quiz)
                            .onTapGesture {
                                viewModel.selectQuiz(quiz)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

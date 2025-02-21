import SwiftUI
import SwiftData

struct QuizLibraryView: View {
    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var badgeViewModel: BadgeGalleryView.ViewModel
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: ViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationDestination(item: $viewModel.selectedQuiz) { quiz in
                    QuizView(quiz: quiz, badgeProgress: badgeViewModel.badgeProgress, quizLibraryViewModel: viewModel)
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

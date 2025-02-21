import SwiftUI
import SwiftData

//FIXME: save previously selected answers
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

struct QuizCard: View {
    let quiz: Quiz
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Text(quiz.icon)
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(quiz.title)
                        .font(.headline)
                    
                    Text(quiz.category)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Group {
                    grammarCorrectedText(count: quiz.questions.count, baseString: "Question")
                    +
                    Text(" • Completed: \(Int(quiz.completion * 100))%")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                ProgressView(value: quiz.completion)
                    .tint(.blue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
} 

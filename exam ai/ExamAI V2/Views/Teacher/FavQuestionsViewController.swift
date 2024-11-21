import SwiftUI

struct FavQuestionsViewController: View {
    @StateObject private var viewModel = FavQuestionsViewModel()
    @State private var searchText = ""
    @State private var showAddQuestionSheet = false

    var body: some View {
        NavigationView {
            VStack {
                // Header with title and plus button
                HStack {
                    Text("Favorite Questions")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading, 20)    
                    Spacer()
                    Button(action: {
                        showAddQuestionSheet.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.top, 20)
  
                // Search bar
                HStack {
                    TextField("Search questions...", text: $searchText)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 10)

                // List of favorite questions
                ScrollView {
                    VStack {
                        ForEach(filteredQuestions, id: \.id) { question in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(question.question)
                                        .fontWeight(.semibold)
                                    Text("Chapter: \(question.chapter)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    copyToClipboard(question.question)
                                }) {
                                    Image(systemName: "doc.on.doc")
                                        .font(.title)
                                        .padding()
                                        .background(Circle().fill(Color.blue.opacity(0.1)))
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            Divider()
                        }
                    }
                }
                .task {
                    await viewModel.fetchFavQuestions() // Fetch questions when view appears
                }
                
                Spacer()
            }
            .navigationBarHidden(true) // Hide the default navigation bar for custom header
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .sheet(isPresented: $showAddQuestionSheet) {
            //   AddQuestionView(questions: $viewModel.questions)
            }
        }
    }
    
    // Filter questions based on search text
    var filteredQuestions: [FavQuestions] {
        if searchText.isEmpty {
            return viewModel.questions
        } else {
            return viewModel.questions.filter { $0.question.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Copy question text to clipboard
    func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
}


struct FavQuestionsViewController_Previews: PreviewProvider {
    static var previews: some View {
        FavQuestionsViewController()
    }
}

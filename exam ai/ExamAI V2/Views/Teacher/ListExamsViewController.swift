import SwiftUI

struct ListExamsViewController: View {
    @State private var searchText: String = ""
    @State private var showFilterOptions: Bool = false
    @State private var selectedExam: Exam? = nil
    @ObservedObject var viewModel = ExamsViewModel()  // Bind the view model
    
    // To control showing the error alert
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                headerView
                searchAndFilterView
                examListView
            }
            .navigationBarHidden(true) // Hide the default navigation bar for custom header
            .onAppear {
                // Call the async fetchExams function within a Task
                Task {
                    await viewModel.fetchExams() // Fetch exams when the view appears
                }
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown error occurred"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: viewModel.errorMessage) { newValue in
                if newValue != nil {
                    showErrorAlert = true  // Trigger the alert when there's an error message
                }
            }
        }
    }
    
    // Header View
    private var headerView: some View {
        HStack {
            Text("Exam AI")
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading, 20)
            
            Spacer()
            
            NavigationLink(destination: ProfileViewController()) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                    .padding(.trailing, 20)
                    .accessibilityLabel(Text("Profile"))
            }
        }
        .padding(.top, 20)
    }
    
    // Search and Filter View
    private var searchAndFilterView: some View {
        HStack {
            TextField("Search exams...", text: $searchText)
                .padding(.leading, 20)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 40)
                .accessibilityLabel(Text("Search exams"))
            
            Button(action: {
                showFilterOptions.toggle()
            }) {
                Image(systemName: "line.horizontal.3.decrease.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 20)
                    .accessibilityLabel(Text("Filter options"))
            }
            
            Button(action: {
                // Perform the search action
            }) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 20)
                    .accessibilityLabel(Text("Search"))
            }
        }
        .padding(.horizontal, 10)
    }
    
    // Exam List View
    private var examListView: some View {
        List(viewModel.exams.filter { searchText.isEmpty ? true : $0.id.contains(searchText) }) { exam in
            VStack {
                examRow(exam)
                if selectedExam?.id == exam.id {
                    examActionButtons(exam)
                }
            }
        }
    }
    
    // Exam Row View
    private func examRow(_ exam: Exam) -> some View {
        HStack {
            Image(systemName: "doc.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(exam.id)
                    .fontWeight(.bold)
                    .accessibilityLabel(Text("Exam ID: \(exam.id)"))
                Text("Grade: \(exam.grade)")  // Display grade instead of date
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .accessibilityLabel(Text("Grade: \(exam.grade)"))
                Text("Chapters: \(exam.chapters.joined(separator: ", "))") // Display chapters
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .accessibilityLabel(Text("Chapters: \(exam.chapters.joined(separator: ", "))"))
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .onTapGesture {
            // Toggle selected exam on tap
            if selectedExam?.id == exam.id {
                selectedExam = nil // Deselect if the same exam is tapped again
            } else {
                selectedExam = exam // Select the new exam
            }
        }
    }
    
    // Exam Action Buttons View
    private func examActionButtons(_ exam: Exam) -> some View {
        HStack {
            Button(action: {
                // Share Action
            }) {
                Text("Share")
                    .foregroundColor(.blue)
                    .accessibilityLabel(Text("Share exam"))
            }
            Spacer()
            Button(action: {
                // View Action
            }) {
                Text("View")
                    .foregroundColor(.blue)
                    .accessibilityLabel(Text("View exam"))
            }
            Spacer()
            Button(action: {
                // Call the async delete function within a Task
                Task {
                    await viewModel.deleteExam(id: exam.id) // Delete Action
                }
            }) {
                Text("Delete")
                    .foregroundColor(.red)
                    .accessibilityLabel(Text("Delete exam"))
            }
        }
        .padding(.top, 10)
    }
}

struct ListExamsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ListExamsViewController()
    }
}

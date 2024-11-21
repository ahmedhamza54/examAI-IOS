import SwiftUI

struct ListExamAttemptsViewController: View {
    @State private var searchText: String = ""
    @State private var showFilterOptions: Bool = false
    @State private var selectedAttempt: ExamAttempt? = nil

    // Sample exam attempt data (replace with actual dynamic data)
    let examAttempts = [
        ExamAttempt(name: "Math Exam", date: "2024-11-10", grade: "A"),
        ExamAttempt(name: "English Exam", date: "2024-11-15", grade: "B+"),
        ExamAttempt(name: "Science Exam", date: "2024-11-20", grade: "A-")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Header Section
                HStack {
                    Text("ExamAI")
                        .font(.title)  // Make the label bigger
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.leading, 20)  // Add padding to the left
                        .frame(maxWidth: .infinity, alignment: .leading) // Align left
                        .padding(.top, 20)  // Add space from top

                    Spacer()
                    
                    // Profile Button
                    NavigationLink(destination: ProfileViewController()) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                            .padding(.trailing, 20)
                    }
                }
                
                // Search bar and filter icon
                HStack {
                    TextField("Search exam attempts...", text: $searchText)
                        .padding(.leading, 20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 40)
                    
                    Button(action: {
                        showFilterOptions.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 20)
                    }
                    
                    Button(action: {
                        // Perform the search action
                    }) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.horizontal, 10)

                // Add "Exam attempts" label above the list
                Text("Exam Attempts")
                    .font(.title)  // Make the label bigger
                    .fontWeight(.bold)
                    .padding(.top, 20) // Add space from the search bar
                    .padding(.leading, 20)  // Align to the left
                    .frame(maxWidth: .infinity, alignment: .leading)  // Align left

                // TableView to display exam attempts
                List(examAttempts.filter { searchText.isEmpty ? true : $0.name.contains(searchText) }) { attempt in
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(attempt.name)
                                    .fontWeight(.bold)
                                Text("Date: \(attempt.date)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Grade: \(attempt.grade)")
                                    .font(.subheadline)
                                    .foregroundColor(attempt.grade == "A" ? .green : (attempt.grade == "B+" ? .blue : .orange))
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .onTapGesture {
                            // Toggle selected attempt on tap
                            if selectedAttempt?.id == attempt.id {
                                selectedAttempt = nil // Deselect if the same attempt is tapped again
                            } else {
                                selectedAttempt = attempt // Select the new attempt
                            }
                        }
                        
                        // Only show the action buttons if this attempt is selected
                        if selectedAttempt?.id == attempt.id {
                            HStack {
                                Button(action: {
                                    // Share Action
                                }) {
                                    Text("Share")
                                        .foregroundColor(.blue)
                                }
                                Spacer()
                                Button(action: {
                                    // View Action (view detailed attempt info)
                                }) {
                                    Text("View")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.top, 10)
                        }
                    }
                }
            }
            .navigationBarHidden(true) // Hide the default navigation bar for custom header
        }
    }
}

struct ExamAttempt: Identifiable {
    var id = UUID()
    var name: String
    var date: String
    var grade: String
}

struct ListExamAttemptsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ListExamAttemptsViewController()
    }
}

// Placeholder for ProfileViewController

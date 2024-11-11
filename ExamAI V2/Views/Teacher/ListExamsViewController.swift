import SwiftUI

struct ListExamsViewController: View {
    @State private var searchText: String = ""
    @State private var showFilterOptions: Bool = false
    @State private var selectedExam: Exam? = nil

    // Sample exam data (you should replace this with dynamic data)
    let exams = [
        Exam(name: "Math Exam", date: "2024-11-10", numberOfPages: 10, imageName: "exam1"),
        Exam(name: "English Exam", date: "2024-11-15", numberOfPages: 12, imageName: "exam2"),
        Exam(name: "Science Exam", date: "2024-11-20", numberOfPages: 8, imageName: "exam3")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Header Section
                HStack {
                    Text("My Exams")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    
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
                .padding(.top, 20)
                
                // Search bar and filter icon
                HStack {
                    TextField("Search exams...", text: $searchText)
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
                
                // TableView to display exams
                List(exams.filter { searchText.isEmpty ? true : $0.name.contains(searchText) }) { exam in
                    VStack {
                        HStack {
                            Image(exam.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text(exam.name)
                                    .fontWeight(.bold)
                                Text(exam.date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Pages: \(exam.numberOfPages)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
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
                        
                        // Only show the action buttons if this exam is selected
                        if selectedExam?.id == exam.id {
                            HStack {
                                Button(action: {
                                    // Share Action
                                }) {
                                    Text("Share")
                                        .foregroundColor(.blue)
                                }
                                Spacer()
                                Button(action: {
                                    // Edit Action
                                }) {
                                    Text("Edit")
                                        .foregroundColor(.blue)
                                }
                                Spacer()
                                Button(action: {
                                    // View Action
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

struct Exam: Identifiable {
    var id = UUID()
    var name: String
    var date: String
    var numberOfPages: Int
    var imageName: String
}

struct ListExamsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ListExamsViewController()
    }
}

// Placeholder for ProfileViewController


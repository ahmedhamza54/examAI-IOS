import SwiftUI

struct MyClassViewController: View {
    @State private var searchText: String = ""  // Search bar text
    @State private var showFilterOptions: Bool = false  // For showing filter options
    @State private var students: [Student] = []  // List of students in the class
    
    // Sample student data (can be expanded with more students)
    let allStudents = [
        Student(name: "Alice Johnson", imageName: "student1"),
        Student(name: "Bob Smith", imageName: "student2"),
        Student(name: "Charlie Brown", imageName: "student3"),
        Student(name: "David Lee", imageName: "student4"),
        Student(name: "Emma Davis", imageName: "student5"),
        Student(name: "Grace Taylor", imageName: "student6")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Header Section
                HStack {
                    Text("My Class")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    // Filter Button
                    Button(action: {
                        showFilterOptions.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 20)
                    }
                }
                
                // Search Bar Section
                HStack {
                    TextField("Search students...", text: $searchText)
                        .padding(.leading, 20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 40)
                    
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
                
                // Display list of students
                List(filteredStudents) { student in
                    HStack {
                        // Student Image
                        Image(student.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        // Student Name
                        VStack(alignment: .leading) {
                            Text(student.name)
                                .fontWeight(.bold)
                            // Additional student info can be added here if needed
                        }
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Load students when the view appears
                loadRandomStudents()
            }
        }
    }
    
    // Computed property to filter students based on the search text
    var filteredStudents: [Student] {
        if searchText.isEmpty {
            return students
        } else {
            return students.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Function to load random students
    func loadRandomStudents() {
        students = Array(allStudents.shuffled().prefix(5)) // Display 5 random students
    }
}

struct Student: Identifiable {
    var id = UUID()
    var name: String
    var imageName: String
}

struct MyClassViewController_Previews: PreviewProvider {
    static var previews: some View {
        MyClassViewController()
    }
}

import SwiftUI

struct FavoriteExamsViewController: View {
    @State private var favoriteExams: [FExam] = []  // List to store favorite exams
    @State private var showAddExamView: Bool = false // Flag to show the add exam view
    
    // Sample FExam data (can be expanded to any number of exams)
    let allExams = [
        FExam(name: "Math Exam", level: "Intermediate", numberOfPages: 10),
        FExam(name: "English Exam", level: "Beginner", numberOfPages: 12),
        FExam(name: "Science Exam", level: "Advanced", numberOfPages: 8),
        FExam(name: "History Exam", level: "Advanced", numberOfPages: 15),
        FExam(name: "Geography Exam", level: "Beginner", numberOfPages: 20),
        FExam(name: "Chemistry Exam", level: "Intermediate", numberOfPages: 14)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Header Section
                HStack {
                    Text("Favorite Exams")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)

                    Spacer()
                    
                    // Plus Button to Add Favorite Exam
                    Button(action: {
                        // Trigger to add exam to the favorites
                        showAddExamView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                            .padding(.trailing, 20)
                    }
                }
                
                // Display favorite exams (Without List, using VStack or HStack)
                ScrollView {
                    VStack(spacing: 20) {
                        // Explicitly type `favoriteExams` as `[FExam]` for `ForEach`
                        ForEach(favoriteExams, id: \.id) { exam in
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(exam.name)
                                            .fontWeight(.bold)
                                        Text("Level: \(exam.level)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text("Pages: \(exam.numberOfPages)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                }

                // Show Add Exam view when flag is true
                if showAddExamView {
                    VStack {
                        ForEach(allExams.shuffled().prefix(3), id: \.id) { exam in  // Take the first 3 random exams
                            Button(action: {
                                // Add the selected exam to favorites
                                favoriteExams.append(exam)
                                showAddExamView = false
                            }) {
                                Text("Add \(exam.name) to Favorites")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.top, 10)
                            }
                        }
                    }
                    .padding(.top, 20)
                    .transition(.slide)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Generate random favorite exams when the view appears
                favoriteExams = Array(allExams.shuffled().prefix(3)) // Pick 3 random exams for favorites
            }
        }
    }
}

struct FExam: Identifiable {
    var id = UUID()
    var name: String
    var level: String
    var numberOfPages: Int
}

struct FavoriteExamsViewController_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteExamsViewController()
    }
}

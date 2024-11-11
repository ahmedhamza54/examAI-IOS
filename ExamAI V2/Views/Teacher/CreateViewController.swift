import SwiftUI

struct CreateViewController: View {
    @State private var selectedGrade: String? = nil
    @State private var selectedSemester: String? = nil
    @State private var selectedChapters: Set<String> = []
    @State private var difficulty: Double = 5 // Difficulty slider value (1-10)
    @State private var prompt: String = ""
    
    let grades = ["7eme", "8eme", "9eme"]
    let semesters = ["1st", "2nd", "3rd"]
    let chapters = ["Chapter 1", "Chapter 2", "Chapter 3", "Chapter 4"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Description label
                Text("Create your exam preferences")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // Grade Selection
                VStack {
                    Text("Grade")
                        .font(.headline)
                    
                    HStack {
                        ForEach(grades, id: \.self) { grade in
                            Button(action: {
                                withAnimation {
                                    selectedGrade = grade
                                    selectedSemester = nil // Reset semester when grade changes
                                    selectedChapters.removeAll() // Reset chapters when grade changes
                                }
                            }) {
                                Text(grade)
                                    .padding()
                                    .background(selectedGrade == grade ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                // Semester Selection (only show if a grade is selected)
                if let selectedGrade = selectedGrade {
                    VStack {
                        Text("Semester")
                            .font(.headline)
                        
                        HStack {
                            ForEach(semesters, id: \.self) { semester in
                                Button(action: {
                                    withAnimation {
                                        selectedSemester = semester
                                    }
                                }) {
                                    Text(semester)
                                        .padding()
                                        .background(selectedSemester == semester ? Color.blue : Color.gray.opacity(0.3))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                
                // Chapters (only show if a semester is selected)
                if let selectedSemester = selectedSemester {
                    VStack {
                        Text("Chapters")
                            .font(.headline)
                        
                        // Multiple selection of chapters
                        HStack {
                            ForEach(chapters, id: \.self) { chapter in
                                Button(action: {
                                    withAnimation {
                                        if selectedChapters.contains(chapter) {
                                            selectedChapters.remove(chapter)
                                        } else {
                                            selectedChapters.insert(chapter)
                                        }
                                    }
                                }) {
                                    Text(chapter)
                                        .padding()
                                        .background(selectedChapters.contains(chapter) ? Color.blue : Color.gray.opacity(0.3))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                
                // Difficulty Slider (appear when a semester is selected)
                if let selectedSemester = selectedSemester {
                    VStack {
                        Text("Difficulty")
                            .font(.headline)
                        
                        HStack {
                            Text("1 (Easy)")
                            Slider(value: $difficulty, in: 1...10, step: 1)
                                .accentColor(.blue)
                            Text("10 (Hard)")
                        }
                        
                        // Show the chosen difficulty number
                        Text("Selected Difficulty: \(Int(difficulty))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                // Prompt Text Field (only show after semester is selected)
                if let selectedSemester = selectedSemester {
                    VStack {
                        Text("Prompt")
                            .font(.headline)
                        
                        TextField("Enter your exam prompt", text: $prompt)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                }
                
                // Generate Button (only show after semester is selected)
                if selectedSemester != nil {
                    Button(action: {
                        // Generate exam logic here
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Generate")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.top, 20)
                }
            }
            .padding(20)
        }
        .navigationBarTitle("Create Exam", displayMode: .inline)
    }
}

struct CreateViewController_Previews: PreviewProvider {
    static var previews: some View {
        CreateViewController()
    }
}

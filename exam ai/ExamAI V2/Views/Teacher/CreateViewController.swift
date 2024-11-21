import SwiftUI

struct CreateViewController: View {
    @StateObject private var createviewModel = CreateViewModel()
    @StateObject private var regenerateViewModel = RegenerateViewModel() // Create a RegenerateViewModel instance
    let teacherId = "63f6c27f5d0f6e001fc7f2e1"
    let subject = "Math"
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                       
                        // Grade Selection
                        gradeSelectionSection
                        
                        // Semester Selection
                        if let _ = createviewModel.selectedGrade {
                            semesterSelectionSection
                        }
                        
                        // Chapters Selection
                        if let _ = createviewModel.selectedSemester {
                            chaptersSelectionSection
                        }
                        
                        // Difficulty Slider
                        if let _ = createviewModel.selectedSemester {
                            difficultySelectionSection
                        }
                        
                        // Prompt Input
                        if let _ = createviewModel.selectedSemester {
                            promptInputSection
                        }
                        
                        // Generate Button
                        if createviewModel.selectedSemester != nil {
                            generateButton
                        }
                    }
                    .padding(20)
                }
                
                // Loading Overlay
                if createviewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationBarTitle("Create Exam", displayMode: .inline)
            .background(
                NavigationLink(
                    destination: ExamPreviewPage(
                        viewModel: regenerateViewModel,  // Pass RegenerateViewModel here
                        pdfURL: createviewModel.pdfURL ?? URL(string: "about:blank")!,
                        examId: $createviewModel.examId,  // Pass the binding for examId
                        oldText: $createviewModel.examText,  // Pass examText for regeneration
                        newPrompt: $createviewModel.newPrompt  // Pass the new prompt
                    ),
                    isActive: $createviewModel.shouldNavigateToExamPreview,
                    label: { EmptyView() }
                )
    


            )
        }
    }
    
    
    private var gradeSelectionSection: some View {
        VStack {
            Text("Grade").font(.headline)
            HStack {
                ForEach(createviewModel.grades, id: \.self) { grade in
                    Button(action: {
                        withAnimation {
                            createviewModel.selectedGrade = grade
                            createviewModel.selectedSemester = nil
                            createviewModel.selectedChapters.removeAll()
                        }
                    }) {
                        Text(grade)
                            .padding()
                            .background(createviewModel.selectedGrade == grade ? Color.blue : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    private var semesterSelectionSection: some View {
        VStack {
            Text("Semester").font(.headline)
            HStack {
                ForEach(createviewModel.semesters, id: \.self) { semester in
                    Button(action: {
                        withAnimation {
                            createviewModel.selectedSemester = semester
                        }
                    }) {
                        Text(semester)
                            .padding()
                            .background(createviewModel.selectedSemester == semester ? Color.blue : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    private var chaptersSelectionSection: some View {
        VStack {
            Text("Chapters").font(.headline)
            HStack {
                ForEach(createviewModel.chapters, id: \.self) { chapter in
                    Button(action: {
                        withAnimation {
                            if createviewModel.selectedChapters.contains(chapter) {
                                createviewModel.selectedChapters.remove(chapter)
                            } else {
                                createviewModel.selectedChapters.insert(chapter)
                            }
                        }
                    }) {
                        Text(chapter)
                            .padding()
                            .background(createviewModel.selectedChapters.contains(chapter) ? Color.blue : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    private var difficultySelectionSection: some View {
        VStack {
            Text("Difficulty").font(.headline)
            HStack {
                Text("1 (Easy)")
                Slider(value: $createviewModel.difficulty, in: 1...10, step: 1)
                    .accentColor(.blue)
                Text("10 (Hard)")
            }
            Text("Selected Difficulty: \(Int(createviewModel.difficulty))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }

    private var promptInputSection: some View {
        VStack {
            Text("Prompt").font(.headline)
            TextField("Enter your exam prompt", text: $createviewModel.prompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }

    private var generateButton: some View {
           Button(action: {
               createviewModel.generateExam(teacherId: teacherId, subject: subject)
           }) {
               HStack {
                   Image(systemName: "sparkles")
                   Text("Generate").fontWeight(.bold)
               }
               .padding()
               .background(Color.blue)
               .foregroundColor(.white)
               .cornerRadius(8)
           }
           .padding(.top, 20)
       }

       private var loadingOverlay: some View {
           ZStack {
               Color.white.opacity(0.7)
                   .edgesIgnoringSafeArea(.all)
               Text("Generating\(createviewModel.loadingDots)")
                   .font(.headline)
                   .bold()
                   .foregroundColor(.black)
           }
       }
   }

struct CreateViewController_Previews: PreviewProvider {
    static var previews: some View {
        CreateViewController()
    }
}

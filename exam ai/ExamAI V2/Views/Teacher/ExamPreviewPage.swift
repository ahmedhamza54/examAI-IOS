import SwiftUI
import PDFKit
import UIKit

var newgenerated: String?

struct ExamPreviewPage: View {
    @ObservedObject var viewModel: RegenerateViewModel
    @State private var isPDFExpanded: Bool = false
    @State private var feedback: String = ""
    @State private var isLoading: Bool = false
    
    // Make pdfURL a state variable
    @State private var pdfURL: URL
    
    @Binding var examId: String
    @Binding var oldText: String
    @Binding var newPrompt: String

    // Explicitly mark the initializer as public or internal
    public init(viewModel: RegenerateViewModel, pdfURL: URL, examId: Binding<String>, oldText: Binding<String>, newPrompt: Binding<String>) {
        self.viewModel = viewModel
        self._pdfURL = State(initialValue: pdfURL) // Initialize pdfURL with passed value
        self._examId = examId
        self._oldText = oldText
        self._newPrompt = newPrompt
    }
    
    var body: some View {
        ZStack {
            VStack {
                // Exam Preview Section
                Text("Exam Preview")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)

                Spacer()

                if !isPDFExpanded {
                    // PDF Viewer Section in Normal State
                    PDFViewer(url: pdfURL)
                        .frame(height: UIScreen.main.bounds.height / 2.5)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .onTapGesture {
                            withAnimation {
                                isPDFExpanded = true
                            }
                        }
                        .padding(.horizontal)
                }

                Spacer()

                // Feedback Section
                VStack {
                    TextField("Didn't like something?", text: $feedback)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        regenerateExam()
                    }) {
                        Text("Regenerate")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.pink]),
                                startPoint: .leading,
                                endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    HStack(spacing: 10) {
                        Button(action: {
                            // Handle share as action
                            sharePDF()
                        }) {
                            Text("Share As")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            // Handle edit action
                        }) {
                            Text("Edit")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.red)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)

                // Loading indicator
                if isLoading {
                    ProgressView("Regenerating...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            }

            // PDF Viewer Section in Expanded State
            if isPDFExpanded {
                PDFViewer(url: pdfURL)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isPDFExpanded = false
                        }
                    }
            }
        }
        .padding()
    }

    // Function to handle regeneration
    func regenerateExam() {
        print("Regenerating exam with ID: \(examId)")
        
        if let unwrappedString = newgenerated {
            oldText = unwrappedString
        }
        
        newPrompt = feedback // Set new prompt from the feedback
        print("Exam ID: \(examId)")
        print("Old Text: \(oldText)")
        print("New Prompt: \(newPrompt)")

        // Ensure we have the required inputs (examId, oldText, and newPrompt)
        guard !examId.isEmpty, !oldText.isEmpty, !newPrompt.isEmpty else {
            print("Missing inputs for regeneration.")
            return
        }
        
        // Set the regeneration parameters in the view model
        viewModel.examId = examId
        viewModel.oldText = oldText
        viewModel.newPrompt = newPrompt
        
        // Set loading state
        isLoading = true
        
        // Call the regenerateExam function from the view model
        viewModel.regenerateExam { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let newPDF):
                    // Handle success, update the PDF
                    print("Successfully regenerated the exam.")
                    self.pdfURL = newPDF // Update with the new PDF URL (if needed)
                    newgenerated = self.viewModel.newExamText
                case .failure(let error):
                    // Handle error
                    print("Error regenerating the exam: \(error)")
                }
            }
        }
    }
    
    // Share PDF Function
    func sharePDF() {
        let activityController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(activityController, animated: true, completion: nil)
        }
    }
}

// PDF Viewer with PDFKit
struct PDFViewer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        } else {
            print("Error: Unable to load PDF document")
        }
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

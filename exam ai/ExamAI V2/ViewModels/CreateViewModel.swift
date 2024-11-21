import SwiftUI
import Combine
import PDFKit

class CreateViewModel: ObservableObject {
    // Form inputs
    @Published var selectedGrade: String? = nil
    @Published var selectedSemester: String? = nil
    @Published var selectedChapters: Set<String> = []
    @Published var difficulty: Double = 5
    @Published var prompt: String = ""

    // Loading state
    @Published var isLoading: Bool = false
    @Published var loadingDots: String = "."
    
    // Navigation state
    @Published var shouldNavigateToExamPreview: Bool = false
    
    // Backend response
    @Published var examText: String = "" // Store examText here
    @Published var examId: String = ""   // Store examId here
    
    // PDF URL to be passed to ExamPreviewPage
    @Published var pdfURL: URL?
    
    // For regeneration purpose
    @Published var oldText: String = ""  // Added for regeneration
    @Published var newPrompt: String = "" // Added for regeneration

    let grades = ["7th", "8th", "9th"]
    let semesters = ["1st", "2nd", "3rd"]
    let chapters = ["Chapter 1", "Chapter 2", "Chapter 3", "Chapter 4"]

    private var loadingCancellable: AnyCancellable?
    private let backendURL = const.BACKEND_URL+"/exams" // Replace with actual backend URL
    
    func generateExam(teacherId: String, subject: String) {
        guard let selectedGrade = selectedGrade else { return }
        
        let requestBody: [String: Any] = [
            "teacherId": teacherId,
            "subject": subject,
            "grade": selectedGrade,
            "chapters": Array(selectedChapters),
            "difficultyLevel": Int(difficulty),
            "prompt": prompt
        ]
        
        guard let url = URL(string: backendURL) else {
            print("Invalid backend URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = requestData
        } catch {
            print("Failed to serialize request body: \(error)")
            return
        }
        
        // Set loading state
        isLoading = true
        startLoadingAnimation()
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.loadingCancellable?.cancel()
            }
            
            if let error = error {
                print("Network error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201,
                  let data = data else {
                print("Invalid response or no data")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let text = json["text"] as? String,
                   let id = json["id"] as? String { // Fetch the examId
                    DispatchQueue.main.async {
                        self?.examText = text
                        self?.examId = id // Store the examId
                        self?.generatePDF(from: text)
                        self?.shouldNavigateToExamPreview = true
                    }
                } else {
                    print("Invalid JSON structure")
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }.resume()
    }
    
    // Generate PDF and store URL
    private func generatePDF(from text: String) {
        // Create PDF from text
        let pdfData = createPDF(from: text)

        // Log to check if PDF is being created
        print("Generated PDF data size: \(pdfData.count) bytes")
        
        // Save PDF to file system
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pdfURL = directoryURL.appendingPathComponent("exam_preview.pdf")
        
        do {
            try pdfData.write(to: pdfURL)
            DispatchQueue.main.async {
                self.pdfURL = pdfURL // Save the generated PDF URL
                print("PDF URL: \(pdfURL)") // Log the PDF URL
            }
        } catch {
            print("Failed to save PDF: \(error)")
        }
    }

    private func createPDF(from text: String) -> Data {
        let pageBounds = CGRect(x: 0, y: 0, width: 612, height: 792) // Standard US Letter size
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: pageBounds)
        
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.black
            ]
            text.draw(in: pageBounds.insetBy(dx: 20, dy: 20), withAttributes: attributes)
        }
        
        return pdfData
    }

    private func startLoadingAnimation() {
        loadingCancellable = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.loadingDots = self.loadingDots.count >= 6 ? "." : self.loadingDots + "."
            }
    }
}

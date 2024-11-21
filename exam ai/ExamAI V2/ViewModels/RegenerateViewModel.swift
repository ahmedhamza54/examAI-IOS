import SwiftUI
import Combine
import PDFKit

class RegenerateViewModel: ObservableObject {
    @Published var examId: String = ""
    @Published var oldText: String = ""
    @Published var newPrompt: String = ""
    @Published var newExamText: String = ""
    @Published var newPdfURL: URL?
    @Published var isLoading: Bool = false
    @Published var loadingDots: String = "."

    private var loadingCancellable: AnyCancellable?
    private let backendURL = const.BACKEND_URL + "/exams/regenerate"

    func regenerateExam(completion: @escaping (Result<URL, Error>) -> Void) {
        guard !examId.isEmpty, !oldText.isEmpty, !newPrompt.isEmpty else {
            print("Missing inputs for regeneration")
            return
        }

        DispatchQueue.main.async {
            self.isLoading = true
            self.startLoadingAnimation()
        }

        let requestBody: [String: Any] = [
            "id": examId,
            "text": oldText,
            "prompt": newPrompt
        ]

        guard let url = URL(string: backendURL) else {
            print("Invalid backend URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                print("Failed to regenerate exam:", error)
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                return
            }

            if let result = try? JSONDecoder().decode(RegenerateResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.newExamText = result.text
                }

                // Generate PDF with added delay to ensure file readiness
                DispatchQueue.global().async {
                    if let pdfURL = PDFGenerator.createPDF(from: result.text) {
                        let delay = DispatchTime.now() + 0.2 // Slight delay to allow file system to update
                        DispatchQueue.global().asyncAfter(deadline: delay) {
                            let fileExists = FileManager.default.fileExists(atPath: pdfURL.path)
                            let fileSize = (try? Data(contentsOf: pdfURL).count) ?? 0

                            print("Generated PDF URL: \(pdfURL)")
                            print("File exists: \(fileExists), Size: \(fileSize) bytes")

                            if fileExists && fileSize > 0 {
                                DispatchQueue.main.async {
                                    self.newPdfURL = pdfURL
                                    completion(.success(pdfURL))
                                }
                            } else {
                                DispatchQueue.main.async {
                                    completion(.failure(NSError(domain: "PDFFileError", code: 0, userInfo: [NSLocalizedDescriptionKey: "PDF file not found or empty"])))
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: "PDFGenerationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to generate PDF"])))
                        }
                    }
                }
            } else {
                print("Failed to decode response")
                completion(.failure(NSError(domain: "DecodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode server response"])))
            }
        }.resume()
    }

    private func startLoadingAnimation() {
        loadingCancellable = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.loadingDots = (self.loadingDots.count < 3) ? self.loadingDots + "." : "."
            }
    }
}

struct RegenerateResponse: Codable {
    var text: String
    var id: String
}

import SwiftUI

@MainActor
class ExamsViewModel: ObservableObject {
    @Published var exams: [Exam] = []
    @Published var errorMessage: String? = nil  // Add error message property
    
    // Fetch exams from the backend using async/await
    func fetchExams() async {
        guard let url = URL(string: const.BACKEND_URL + "/exams") else {
            errorMessage = "Invalid URL"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decoding response data into Exam objects
            let decodedExams = try JSONDecoder().decode([Exam].self, from: data)
            exams = decodedExams
        } catch {
            // Handle any errors during the request or decoding process
            errorMessage = "Failed to load exams: \(error.localizedDescription)"
        }
    }
    
    // Delete an exam using async/await
    func deleteExam(id: String) async {
        guard let url = URL(string: const.BACKEND_URL + "/exams/\(id)") else {
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // If delete is successful, remove from the local list
                exams.removeAll { $0.id == id }
            } else {
                errorMessage = "Failed to delete exam"
            }
        } catch {
            // Handle any errors during the request
            errorMessage = "Failed to delete exam: \(error.localizedDescription)"
        }
    }
}

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var navigateToHome = false
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    // Regular expression for basic email validation
    private let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    
    // Method to check if the username is a valid email
    private func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // Modified login method that accepts a completion handler
    func login(completion: @escaping (Bool) -> Void) {
        // Validate email format
        guard isValidEmail(email) else {
            self.errorMessage = "Please enter a valid email address."
            completion(false)  // Login failed due to invalid email
            return
        }

        // Check for non-empty password
        guard !password.isEmpty else {
            self.errorMessage = "Password cannot be empty."
            completion(false)  // Login failed due to empty password
            return
        }

        self.isLoading = true
        self.errorMessage = nil

        // Prepare and send the login request here (assuming the request code is already implemented)
        var request = URLRequest(url: URL(string: const.BACKEND_URL+"/auth/login/")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginDetails = ["email": email, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: loginDetails) else {
            self.errorMessage = "Invalid login details."
            self.isLoading = false
            completion(false)  // Login failed due to invalid login details
            return
        }
        
        request.httpBody = jsonData
        
        // Send the request and handle the response
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data -> LoginResponse in
                if let successResponse = try? JSONDecoder().decode(LoginSuccessResponse.self, from: data) {
                    return .success(successResponse)
                }
                if let errorResponse = try? JSONDecoder().decode(LoginErrorResponse.self, from: data) {
                    return .failure(errorResponse)
                }
                throw URLError(.badServerResponse)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionResult in
                self.isLoading = false
                if case let .failure(error) = completionResult {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                    completion(false)  // Login failed due to error
                }
            }, receiveValue: { response in
                switch response {
                case .success(let successResponse):
                    // Store tokens as needed
                    let accessToken = successResponse.accessToken
                    let refreshToken = successResponse.refreshToken
                    let userId = successResponse.userId
                    self.navigateToHome = true
                    completion(true)  // Login succeeded
                    
                case .failure(let errorResponse):
                    // Display error message from backend
                    self.errorMessage = errorResponse.message
                    completion(false)  // Login failed due to backend error
                }
            })
            .store(in: &cancellables)
    }
}

// Models for decoding responses
struct LoginSuccessResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let userId: String
}

struct LoginErrorResponse: Codable {
    let statusCode: Int
    let message: String
    let error: String
}

enum LoginResponse {
    case success(LoginSuccessResponse)
    case failure(LoginErrorResponse)
}

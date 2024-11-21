import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var role: String = "Teacher"
    @Published var errorMessage: String?
    @Published var isSignedUp = false
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()
    
    private let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"

    private func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func validateInputs() -> Bool {
        guard !name.isEmpty else {
            errorMessage = "Name is required."
            return false
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty."
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }

        errorMessage = nil
        return true
    }
    
    func signUp(completion: @escaping () -> Void) {
        guard validateInputs() else { return }
        
        isLoading = true
        errorMessage = nil

        var signUpDetails: [String: Any] = [
            "name": name,
            "email": email,
            "password": password,
            "role": role
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: signUpDetails) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid signup details."
                self.isLoading = false
            }
            return
        }
        
        var request = URLRequest(url: URL(string: const.BACKEND_URL+"/auth/signup/")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .sink(receiveCompletion: { completionResult in
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                if case let .failure(error) = completionResult {
                    DispatchQueue.main.async {
                        self.errorMessage = "Signup failed: \(error.localizedDescription)"
                    }
                }
            }, receiveValue: { data, response in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                        DispatchQueue.main.async {
                            self.isSignedUp = true
                            completion()  // Notify that sign-up is complete
                        }
                    } else {
                        if let responseString = String(data: data, encoding: .utf8) {
                            DispatchQueue.main.async {
                                self.errorMessage = responseString
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.errorMessage = "An unknown error occurred."
                            }
                        }
                    }
                }
            })
            .store(in: &cancellables)
    }
}




struct SignUpErrorResponse: Codable {
    let statusCode: Int
    let message: String?
    let error: String?
}

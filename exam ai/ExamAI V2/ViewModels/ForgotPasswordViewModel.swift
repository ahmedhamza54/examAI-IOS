import Foundation
import Combine

class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var message: String?
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()
    
    private let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"

    private func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func resetPassword() {
        // Validate email format
        guard isValidEmail(email) else {
            self.message = "Please enter a valid email address."
            return
        }

        self.isLoading = true
        self.message = nil
        
        // Prepare the reset password request
        var request = URLRequest(url: URL(string: const.BACKEND_URL+"/auth/forgot-password/")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let resetDetails = ["email": email]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: resetDetails) else {
            DispatchQueue.main.async {
                self.message = "Invalid email format."
                self.isLoading = false
            }
            return
        }
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    print("Reset Password Error: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                // Always show the success message after request completion
                self.message = "If user exists, they will receive an email."
            })
            .store(in: &cancellables)
    }
}

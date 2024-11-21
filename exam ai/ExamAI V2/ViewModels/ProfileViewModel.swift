import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var name: String = "John Doe" // Default name
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()

    func fetchname(for email: String) {
        guard let url = URL(string: const.BACKEND_URL+"/auth/get-name") else {
            self.errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            self.errorMessage = "Failed to encode request body"
            return
        }
        request.httpBody = jsonData

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main) // Update on main thread
            .tryMap { data, response -> String in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 201 else {
                    throw URLError(.badServerResponse)
                }

                // Decode the response to extract teacher name
                let responseData = try JSONDecoder().decode(ProfileResponse.self, from: data)
                return responseData.name
            }
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = "Failed to fetch teacher name: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] name in
                self?.name = name
            })
            .store(in: &cancellables)
    }
}

// Response model for decoding the backend response
struct ProfileResponse: Codable {
    let name: String
}

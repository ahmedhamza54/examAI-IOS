import SwiftUI

struct ProfileViewController: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isDarkMode = false
    @State private var selectedLanguage = "English"
    
    var body: some View {
        NavigationView {
            VStack {
                // Profile Picture Section
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                // Teacher Name or Loading/ Error Section
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding(.bottom, 20)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                } else {
                    Text(viewModel.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(isDarkMode ? .white : .black)
                        .padding(.bottom, 20)
                }

                // Preferences Section
                VStack(alignment: .leading, spacing: 20) {
                    // Dark Mode Toggle
                    HStack {
                        Text("Dark Mode")
                            .font(.headline)
                            .foregroundColor(isDarkMode ? .white : .black)
                        Spacer()
                        Toggle(isOn: $isDarkMode) {
                            Text(isDarkMode ? "On" : "Off")
                                .foregroundColor(isDarkMode ? .green : .red)
                        }
                        .labelsHidden()
                    }
                    .padding(.horizontal, 20)

                    // Language Selector
                    HStack {
                        Text("Language")
                            .font(.headline)
                            .foregroundColor(isDarkMode ? .white : .black)
                        Spacer()
                        Menu {
                            Button(action: { selectedLanguage = "English" }) { Text("English") }
                            Button(action: { selectedLanguage = "Arabic" }) { Text("Arabic") }
                            Button(action: { selectedLanguage = "French" }) { Text("French") }
                        } label: {
                            Text(selectedLanguage)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)

                Spacer()
            }
            .navigationBarTitle("Profile", displayMode: .inline)
            .background(isDarkMode ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))
            .onAppear {
                if let email = UserDefaults.standard.string(forKey: "loggedInEmail") {
                    viewModel.fetchname(for: email)
                } else {
                    viewModel.errorMessage = "Unable to retrieve email. Please log in again."
                }
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewController()
    }
}

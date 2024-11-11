import SwiftUI

struct ProfileViewController: View {
    // State variables to handle dark mode and language selection
    @State private var isDarkMode = false
    @State private var selectedLanguage = "English"
    
    // Teacher's name and profile picture
    @State private var teacherName = "John Doe" // Replace with dynamic teacher name if needed
    @State private var profilePic = Image(systemName: "person.crop.circle.fill") // Default profile image
    
    // View for the Profile Screen
    var body: some View {
        NavigationView {
            VStack {
                // Profile Picture Section
                profilePic
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
                // Teacher Name
                Text(teacherName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(isDarkMode ? .white : .black) // Change color based on dark mode
                    .padding(.bottom, 20)
                
                // Preferences Section
                VStack(alignment: .leading, spacing: 20) {
                    // Dark Mode Toggle
                    HStack {
                        Text("Dark Mode")
                            .font(.headline)
                            .foregroundColor(isDarkMode ? .white : .black) // Change color based on dark mode
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
                            .foregroundColor(isDarkMode ? .white : .black) // Change color based on dark mode
                        Spacer()
                        Menu {
                            Button(action: {
                                selectedLanguage = "English"
                            }) {
                                Text("English")
                            }
                            Button(action: {
                                selectedLanguage = "Arabic"
                            }) {
                                Text("Arabic")
                            }
                            Button(action: {
                                selectedLanguage = "French"
                            }) {
                                Text("French")
                            }
                        } label: {
                            Text(selectedLanguage)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Privacy Policy and Terms & Conditions
                    HStack {
                        NavigationLink(destination: Text("Privacy Policy")) {
                            Text("Privacy Policy")
                                .font(.subheadline)
                                .foregroundColor(isDarkMode ? .white : .blue) // Change color based on dark mode
                        }
                        Spacer()
                        NavigationLink(destination: Text("Terms and Conditions")) {
                            Text("Terms and Conditions")
                                .font(.subheadline)
                                .foregroundColor(isDarkMode ? .white : .blue) // Change color based on dark mode
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
            .navigationBarTitle("Profile", displayMode: .inline)
            .background(isDarkMode ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))
        }
    }
}
struct profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewController()
    }
}

//#Preview {
   // ProfileViewController()
//}


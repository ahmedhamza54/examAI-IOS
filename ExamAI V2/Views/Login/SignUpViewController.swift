import SwiftUI

struct SignUpView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var role: String = "Teacher" // Default role
    @State private var selectedSubject: String = "Maths" // Default subject
    @State private var selectedGrade: String = "9eme" // Default grade
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var navigateToLogin = false // For navigation to LoginView

    let roles = ["Teacher", "Student"] // Options for role selection
    let subjects = ["Maths", "English", "Arabic"] // Options for subjects
    let grades = ["9eme", "8eme", "7eme"] // Options for grades

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // "Sign-Up" Label
                Text("Sign-Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)

                // Full Name TextField
                TextField("Full Name", text: $fullName)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                // Email TextField
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                // Role Picker
                Picker("Role", selection: $role) {
                    ForEach(roles, id: \.self) { role in
                        Text(role)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)

                // Conditional Subject Picker for Teachers
                if role == "Teacher" {
                    HStack {
                        Picker("Subject", selection: $selectedSubject) {
                            ForEach(subjects, id: \.self) { subject in
                                Text(subject)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity) // Make picker wide
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                }

                // Conditional Grade Picker for Students
                if role == "Student" {
                    HStack {
                        Picker("Grade", selection: $selectedGrade) {
                            ForEach(grades, id: \.self) { grade in
                                Text(grade)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity) // Make picker wide
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                }

                // Password SecureField
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                // Confirm Password SecureField
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                // Sign-Up Button
                Button(action: {
                    // Handle sign-up action
                }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 10)

                Spacer()

                // Already have an account? and Log In button
                .padding(.bottom, 30)
            }
            .navigationTitle("")
            .navigationBarHidden(true) // Hide navigation bar in SignUpView
        }
    }
}
struct signup_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

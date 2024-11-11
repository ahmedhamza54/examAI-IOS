import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var navigateToSignUp = false
    @State private var navigateToHome = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Image at the top center
                Image("exam ai logo")
                    .resizable()
                    .frame(width: 240, height: 180)
                    .foregroundColor(.red)
                    .padding(.top, 50)

                Text("Welcome to ExamAI")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)

                // Username TextField
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                // Password SecureField
                SecureField("Password", text: $password) 
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                // Login Button
                Button(action: {
                    // Trigger navigation to HomeViewController
                    navigateToHome = true
                }) {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }

                // Forgot Password Button
                Button(action: {
                    // Handle forgot password action
                }) {
                    Text("Forgot Password?")
                        .foregroundColor(.red)
                }
                .padding(.top, 10)

                Spacer()

                // Sign Up Option
                HStack {
                    NavigationLink(destination: SignUpView(), isActive: $navigateToSignUp) {
                        EmptyView()
                    }
                    Text("Don't have an account?")
                    Button(action: {
                        navigateToSignUp = true
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                    }
                }
                .padding(.bottom, 30)

                // Navigation link to HomeViewController without a back button
                NavigationLink(destination: HomeViewController().navigationBarBackButtonHidden(true), isActive: $navigateToHome) {
                    EmptyView()
                }
            }
            .navigationTitle("Login")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var navigateToSignUp = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("exam ai logo")
                    .resizable()
                    .frame(width: 240, height: 180)
                    .foregroundColor(.red)
                    .padding(.top, 50)

                Text("Welcome to ExamAI")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                // Email TextField
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                // Password SecureField
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                // Display error message if login fails
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Login Button
                Button(action: {
                    viewModel.login { success in
                        if success {
                            // Save email to UserDefaults after successful login
                            UserDefaults.standard.set(viewModel.email, forKey: "loggedInEmail")
                        }
                    }
                }) {
                    Text(viewModel.isLoading ? "Logging in..." : "Login")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .disabled(viewModel.isLoading)

                // Forgot Password NavigationLink
                NavigationLink(destination: ForgotPasswordView()) {
                    Text("Forgot Password?")
                        .foregroundColor(.red)
                }
                .padding(.top, 10)

                Spacer()

                // Sign Up Link
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

                // Navigation to HomeView
                NavigationLink(destination: HomeViewController().navigationBarBackButtonHidden(true), isActive: $viewModel.navigateToHome) {
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

//hamza@gmail.com
//1234567
//http://192.168.125.121:3000/auth/login/
//http://192.168.125.121:3000/auth/get-name

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            TextField("Enter your email", text: $viewModel.email)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 20)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            if let message = viewModel.message {
                Text(message)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if viewModel.isLoading {
                ProgressView("Sending request...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }

            Button(action: {
                viewModel.resetPassword()
            }) {
                Text("Reset Password")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
            }
            .padding(.top, 10)
            .disabled(viewModel.isLoading) // Disable button during loading

            Spacer()
        }
        .navigationTitle("Forgot Password")
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

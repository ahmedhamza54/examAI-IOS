import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.presentationMode) var presentationMode  // To control navigation
    @State private var showSuccessMessage = false  // To show the success notification

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sign-Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)

                TextField("Name", text: $viewModel.name)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                Picker("Role", selection: $viewModel.role) {
                    ForEach(["teacher", "student"], id: \.self) { role in
                        Text(role.capitalized) // Capitalize the role name for display
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)

                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if viewModel.isLoading {
                    ProgressView("Signing up...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }

                Button(action: {
                    viewModel.signUp {
                        if viewModel.isSignedUp {
                            // Show success notification and navigate back
                            showSuccessMessage = true
                            // After a short delay, navigate back to the login screen
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
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
                .disabled(viewModel.isLoading) // Disable button during loading

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .alert(isPresented: $showSuccessMessage) {
                Alert(title: Text("Success"), message: Text("Sign-up was successful! You can now log in."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

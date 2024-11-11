import SwiftUI

struct GetStartedView: View {
    @State private var currentPage = 0
    @State private var navigateToLogin = false // State variable for navigation

    var body: some View {
        NavigationView {
            VStack {
                // Swipeable Section with Page Index
                TabView(selection: $currentPage) {
                    // First Tab
                    VStack(spacing: 20) {
                        Image("exam ai logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.top, 50)
                        
                        Text("ExamAI")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Create exams effortlessly")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .tag(0)
                    
                    // Second Tab
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.blue)
                            .padding(.top, 50)
                        
                        Text("Secure & Reliable")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Your exams are safe and secure")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .tag(1)
                    
                    // Third Tab
                    VStack(spacing: 20) {
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.green)
                            .padding(.top, 50)
                        
                        Text("Fast & Easy")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Create exams in minutes")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(maxHeight: .infinity)

                // Page Indicator Dots
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(currentPage == index ? .blue : .gray)
                    }
                }
                .padding(.bottom, 20)

                // Get Started Button at the bottom
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), isActive: $navigateToLogin) {
                    EmptyView()
                }
                
                Button(action: {
                    navigateToLogin = true // Set to true to trigger navigation
                }) {
                    Text("Get Started")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true) // Hide navigation bar in GetStartedView
          
        }
    }
}

struct getStarted_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView()
    }
}

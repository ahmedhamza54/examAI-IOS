import SwiftUI

struct HomeViewController: View {
    @State private var selectedTab = 0 // Manage selected tab state
    @State private var navigateToCreateView = false // State to trigger navigation

    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selectedTab) {
                    // Home Tab
                    VStack {
                        ListExamsViewController()
                    }
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)

                    // Edit Tab
                    VStack {
                        EditorViewController()
                    }
                    .tabItem {
                        Image(systemName: "pencil.circle.fill")
                        Text("Edit")
                    }
                    .tag(1)

                    // Conditional Placeholder Tab for Create
                    Text("Create Content")
                        .tabItem {
                            Image(systemName: "")
                            Text("")
                        }
                        .tag(2)
                        .onAppear {
                            // Whenever the "Create" tab appears, redirect to another tab
                            selectedTab = 0
                            navigateToCreateView = true
                        }

                    // Favorites Tab
                    VStack {
                        FavQuestionsViewController()
                    }
                    .tabItem {
                        Image(systemName: "rectangle.stack")
                        Text("Favorite")
                    }
                    .tag(3)

                    // Students Tab
                    VStack {
                        Text("Students")
                    }
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Students")
                    }
                    .tag(4)
                }
                .accentColor(.red)

                // Custom "Create" Button Overlay
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            navigateToCreateView = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(Circle().fill(Color.white))
                                .foregroundColor(.red)
                                .shadow(radius: 4)
                        }
                        .offset(y: -10)
                        Spacer()
                    }
                }

                // Navigation to CreateViewController
                NavigationLink(
                    destination: CreateViewController(),
                    isActive: $navigateToCreateView,
                    label: { EmptyView() }
                )
            }
            .navigationBarHidden(true)
        }
    }
}

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController()
    }
}

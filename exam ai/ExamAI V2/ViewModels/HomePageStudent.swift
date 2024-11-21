//
//  HomePageStudent.swift
//  ExamAI V2
//
//  Created by Mac Mini 11 on 15/11/2024.
//

import Foundation
import SwiftUI

struct HomePageStudent: View {
    @State private var selectedTab = 0 // Manage selected tab state
    @State private var navigateToCreateView = false // State to trigger navigation

    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selectedTab) {
                    // Home Tab
                    VStack {
                        // Content for Home Tab (Replace with actual content)
                        ListExamAttemptsViewController()
                    }
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)

                    // Attempts Tab
                    VStack {
                        // Content for Attempts Tab (Replace with actual content)
                        MyCalendarViewController()
                        
                    }
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                    .tag(1)

                    // Pass Exam Tab
                    VStack {
                        // Content for Pass Exam Tab (Replace with actual content)
                        PassExamViewController()
                        Text("Pass Exam Content")
                    }
                    .tabItem {
                        Image(systemName: "checkmark.circle.fill")
                        Text("")
                    }
                    .tag(2)

                    // Favorite Exams Tab
                    VStack {
                        // Content for Favorite Exams Tab (Replace with actual content)
                        FavoriteExamsViewController()
                    }
                    .tabItem {
                        Image(systemName: "star.circle.fill")
                        Text("Favorite Exams")
                    }
                    .tag(3)

                    // My Class Tab
                    VStack {
                        // Content for My Class Tab (Replace with actual content)
                        MyClassViewController()
                        
                    }
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("My Class")
                    }
                    .tag(4)
                }
                .accentColor(.red)

                // Custom "Create" Button Overlay (Optional)
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

                // Navigation to CreateViewController (Optional)
                NavigationLink(
                    destination: PassExamViewController(),
                    isActive: $navigateToCreateView,
                    label: { EmptyView() }
                )
            }
            .navigationBarHidden(true)
        }
    }
}

struct HomePageStudent_preview: PreviewProvider {
    static var previews: some View {
        HomePageStudent()
    }
}

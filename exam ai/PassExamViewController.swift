//
//  PassExamViewController.swift
//  ExamAI V2
//
//  Created by mac01L04 on 21/11/2024.
//

import Foundation
import SwiftUI

struct PassExamViewController: View {
    @State private var selectedExam: PExam? = nil  // Track the selected exam
    @State private var showSuccessMessage: Bool = false // Show success message when the exam is passed
    @State private var searchText: String = ""  // Search functionality
    
    // Sample exam data for passing the exam
    let exams = [
        PExam(name: "Math Exam", level: "Intermediate", numberOfPages: 10),
        PExam(name: "English Exam", level: "Beginner", numberOfPages: 12),
        PExam(name: "Science Exam", level: "Advanced", numberOfPages: 8)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Header Section
                HStack {
                    Text("Pass Exam")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)

                    Spacer()
                    
                    // Profile Button (same as before)
                    NavigationLink(destination: ProfileViewController()) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                            .padding(.trailing, 20)
                    }
                }
                
                // Search bar for searching exams
                HStack {
                    TextField("Search exams...", text: $searchText)
                        .padding(.leading, 20)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 40)
                    
                    Button(action: {
                        // Perform search action
                    }) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.horizontal, 10)

                // List of exams
                List(exams.filter { searchText.isEmpty ? true : $0.name.contains(searchText) }) { exam in
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(exam.name)
                                    .fontWeight(.bold)
                                Text("Level: \(exam.level)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Pages: \(exam.numberOfPages)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .onTapGesture {
                            // Set selected exam
                            if selectedExam?.id == exam.id {
                                selectedExam = nil  // Deselect if the same exam is tapped again
                            } else {
                                selectedExam = exam // Select the new exam
                            }
                        }
                        .background(selectedExam?.id == exam.id ? Color.blue.opacity(0.1) : Color.clear)
                        .cornerRadius(8)
                    }
                }

                // "Pass Exam" button (only visible when an exam is selected)
                if selectedExam != nil {
                    Button(action: {
                        // Handle exam pass action
                        showSuccessMessage = true
                    }) {
                        Text("Pass Exam")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.top, 20)
                    }
                }
                
                // Show success message after passing the exam
                if showSuccessMessage {
                    Text("You have successfully passed the exam!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct PExam: Identifiable {
    var id = UUID()
    var name: String
    var level: String
    var numberOfPages: Int
}

struct PassExamViewController_Previews: PreviewProvider {
    static var previews: some View {
        PassExamViewController()
    }
}

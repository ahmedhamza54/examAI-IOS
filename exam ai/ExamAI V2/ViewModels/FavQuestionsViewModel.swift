//
//  FavQuestionsViewModel.swift
//  ExamAI V2
//
//  Created by Apple Esprit on 10/11/2024.
//

import Foundation
import SwiftUI

@MainActor
class FavQuestionsViewModel: ObservableObject {
    @Published var questions: [FavQuestions] = []
    @Published var errorMessage: String? = nil

    func fetchFavQuestions() async {
        let urlString = const.BACKEND_URL+"/fav-questions"
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let questions = try JSONDecoder().decode([FavQuestions].self, from: data)
            self.questions = questions
        } catch {
            errorMessage = "Failed to load questions: \(error.localizedDescription)"
        }
    }
}


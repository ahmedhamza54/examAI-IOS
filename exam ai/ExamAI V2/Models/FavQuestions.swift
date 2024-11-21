//
//  FavQuestions.swift
//  ExamAI V2
//
//  Created by Apple Esprit on 10/11/2024.
//

import Foundation

struct FavQuestions:  Codable{
    let id: String
    let question: String
    let chapter:String
    
    private enum CodingKeys: String, CodingKey {
            case id = "_id"
            case question
            case chapter
        }
    
}

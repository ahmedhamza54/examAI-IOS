//
//  Exam.swift
//  ExamAI V2
//
//  Created by Apple Esprit on 21/11/2024.
//

import Foundation

import Foundation

struct Exam: Codable , Identifiable {
    var id: String // Corresponds to _id in the response
    var teacherId: String
    var subject: String
    var grade: String
    var chapters: [String]
    var difficultyLevel: Int
    var prompt: String
    var v: Int  // __v field in the response
    var text: String  // Exam description
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case teacherId
        case subject
        case grade
        case chapters
        case difficultyLevel
        case prompt
        case v = "__v"
        case text
    }
}

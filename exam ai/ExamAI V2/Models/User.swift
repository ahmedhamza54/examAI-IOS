//
//  User.swift
//  ExamAI V2
//
//  Created by Apple Esprit on 10/11/2024.
//

import Foundation

struct User: Identifiable, Decodable {
    let id: Int
    let name: String
    let email: String
    let role: String
}

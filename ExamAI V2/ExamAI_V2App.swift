//
//  ExamAI_V2App.swift
//  ExamAI V2
//
//  Created by Mac Mini 11 on 8/11/2024.
//

import SwiftUI

@main
struct ExamAI_V2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            GetStartedView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

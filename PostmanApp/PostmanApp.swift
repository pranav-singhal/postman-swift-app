//
//  PostmanAppApp.swift
//  PostmanApp
//
//  Created by Pranav Singhal on 15/04/23.
//

import SwiftUI

@main
struct PostmanApp: App {
    @StateObject private var persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
